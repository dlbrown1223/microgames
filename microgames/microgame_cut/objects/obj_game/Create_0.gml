


//show_debug_overlay(true,true);


maxtime = lerp(60*8,60*6,microgame_get_gamespeed());
scoretime = 60*2;
timer = maxtime;
state = 0;

game_score = undefined;
max_pixel_difference = 500;


randomize();

maxwid = 64;
maxhei = 64;
surf = surface_create(maxwid,maxhei);
surf_preview = surface_create(maxwid,maxhei);
surf_sprite = surface_create(maxwid,maxhei);
changed = true;
checked = true;
checktime = 60;
checktimer = 0;

brush_rad = 2.5;
cutvolume = 0;
cutvolume_targ = 0;
cutsound = -1;

path = choose(
	pt_shape0,
	pt_shape1,
	pt_shape2,
	pt_shape3,
	pt_shape4,
	pt_shape5,
	pt_shape6
);
path_centerpos = {
	
};


buffsize = maxwid*maxhei*4;
buff = buffer_create(buffsize,buffer_fast,1);
buff_group = buffer_create(buffsize,buffer_fast,1);
buffer_fill(buff,0,buffer_u8,255,buffsize);

centerx = room_width/2;
centery = room_height/2;
boardscale = 3;
boardx = centerx-maxwid/2*boardscale;
boardy = centery-maxhei/2*boardscale;

#region drawing/particles

ps = part_system_create();
part_system_automatic_draw(ps,false);

u_texture = shader_get_sampler_index(shd_textured,"texture");

var p = part_type_create();
pt_cardboard = p;
part_type_sprite(p,sp_pixel,0,0,0);
var r = 15;
part_type_direction(p,90-r,90+r,0,0);
part_type_orientation(p,0,360,0,0,0);
part_type_color1(p,#ad795c);
part_type_alpha3(p,1,1,0);
part_type_life(p,30,60);
part_type_speed(p,1.7,2.5,0,0);
part_type_scale(p,2,2); //boardscale
part_type_gravity(p,0.06,270);

#endregion



pixels = 0;
totalpixels = maxwid*maxhei;
groups_clear = function() {
	checkarr = array_create_2d(maxwid,maxhei);
}
get_group = function(xx,yy) {
	//return buffer_peek_2d(buff_group,xx,yy,maxwid,maxhei);
	return checkarr[xx][yy];
}
set_group = function(xx,yy,grp) {
	checkarr[xx][yy] = grp;
}
check_board = function() {
	checked = true;
	//show_debug_message("checking...")
	pixels = 0;
	
	//count full pixels
	var val;
	for(var i=0; i<buffsize; i+=4) {
		val = buffer_peek(buff,i,buffer_u8)/255; //r
		if val>0 {
			pixels += ceil(val);
		}
	}
	
	//show_debug_message($"pixels left: {pixels}");
	
	search_board();
	
}

checkarr = undefined;
checklistx = ds_stack_create();
checklisty = ds_stack_create();
group_pixel_counts = ds_list_create();
queue_pos = function(xx,yy) {
	ds_stack_push(checklistx,xx);
	ds_stack_push(checklisty,yy);
}
get_centerpos = function() {
	static pos = { x: 0, y: 0 };
	var center = path_centerpos[$ path_get_name(path)];
	var cx = floor(maxwid/2);
	var cy = floor(maxhei/2);
	if !is_undefined(center) {
		cx = center.x;
		cy = center.y;
	}
	pos.x = cx;
	pos.y = cy;
	return pos;
}
search_board = function() {
	
	groups_clear();
	ds_stack_clear(checklistx);
	ds_stack_clear(checklisty);
	ds_list_clear(group_pixel_counts);
	
	var groupcount = 1;
	ds_list_add(group_pixel_counts,0);
	var count = 0;
	while(count<pixels) {
		
		//find pixel to start with
		if ds_stack_empty(checklistx) {
			var started = false;
			for(var xx=0; xx<maxwid; xx++) {
				for(var yy=0; yy<maxhei; yy++) {
					if get_group(xx,yy)>0 continue; //already checked
					var val = buffer_peek_2d(buff,xx,yy,maxwid,maxhei); //r
					if val>0 {
						queue_pos(xx,yy);
						set_group(xx,yy,groupcount++);
						ds_list_add(group_pixel_counts,0);
						started = true;
						break;
					}
				}
				if started break;
			}
		}
		
		var px = ds_stack_pop(checklistx);
		var py = ds_stack_pop(checklisty);
		var group = get_group(px,py);
		group_pixel_counts[| group]++
		count++
		
		
		///recurse
		if px>0 {
			var lgroup = get_group(px-1,py);
			if lgroup==0 {
				var left = buffer_peek_2d(buff,px-1,py,maxwid,maxhei);
				if left>0 {
					queue_pos(px-1,py);
					set_group(px-1,py,group);
				}
			}
		}
		if py>0 {
			var ugroup = get_group(px,py-1);
			if ugroup==0 {
				var up = buffer_peek_2d(buff,px,py-1,maxwid,maxhei);
				if up>0 {
					queue_pos(px,py-1);
					set_group(px,py-1,group);
				}
			}
		}
		if px<maxwid-1 {
			var rgroup = get_group(px+1,py);
			if rgroup==0 {
				var right = buffer_peek_2d(buff,px+1,py,maxwid,maxhei);
				if right>0 {
					queue_pos(px+1,py);
					set_group(px+1,py,group);
				}
			}
		}
		if py<maxhei-1 {
			var dgroup = get_group(px,py+1);
			if dgroup==0 {
				var down = buffer_peek_2d(buff,px,py+1,maxwid,maxhei);
				if down>0 {
					queue_pos(px,py+1);
					set_group(px,py+1,group);
				}
			}
		}
		
	}
	
	
	var cpos = get_centerpos();
	var cx = cpos.x;
	var cy = cpos.y;
	var centergroup = get_group(cx,cy)
	
	
	if !surface_exists(surf_sprite) {
		surf_sprite = surface_create(maxwid,maxhei);
	}
	
	var glen = ds_list_size(group_pixel_counts);
	var pcount;
	for(var g=1; g<glen; g++) {
		if g==centergroup continue;
		pcount = group_pixel_counts[| g];
		if pcount==0 continue;
		
		surface_set_target(surf_sprite);
		draw_clear_alpha(c_black,0);
		
		for(var xx=0; xx<maxwid; xx++) {
			for(var yy=0; yy<maxhei; yy++) {
				if get_group(xx,yy)==g {
					var val = buffer_peek_2d(buff,xx,yy,maxwid,maxhei); //r
					if val>0 {
						draw_point(xx,yy);
						buffer_setpixel(buff,xx,yy,maxwid,maxhei,c_black,0);
						set_group(xx,yy,0);
						changed = true;
					}
				}
			}
		}
		
		surface_reset_target();
		
		var spr = sprite_create_from_surface(surf_sprite,0,0,maxwid,maxhei,false,false,0,0);
		var l = sprite_get_bbox_left(spr);
		var t = sprite_get_bbox_top(spr);
		var r = sprite_get_bbox_right(spr);
		var b = sprite_get_bbox_bottom(spr);
		//show_debug_message([l,t,r,b])
		
		var bx = boardx+(l+(r-l)/2)*boardscale;
		var by = boardy+(t+(b-t)/2)*boardscale;
		
		var piece = instance_create_depth(bx,by,0,obj_boardpiece);
		piece.image_xscale = boardscale;
		piece.image_yscale = boardscale;
		piece.scale = boardscale;
		piece.sprite_index = spr;
		
	}
	
	
}


calc_score = function() {
	
	if !checked {
		check_board();
	}
	
	static str = { pass: false, label: "" };
	var pts = 0;
	
	var maxpixels = maxwid*maxhei;
	var inside_filled_count = 0;
	var outside_filled_count = 0;
	
	var filled,inside;
	for(var xx=0; xx<maxwid; xx++) {
		for(var yy=0; yy<maxhei; yy++) {
			filled = buffer_peek_2d(buff,xx,yy,maxwid,maxhei);
			inside = point_inside_shape(xx,yy);
			
			if inside {
				if filled {
					inside_filled_count++
				}
			}
			else {
				if filled {
					outside_filled_count++
				}
			}
		}
	}
	
	
	var points_outside_shape = maxpixels-points_in_shape;
	var perc_outside = 1-(outside_filled_count / points_outside_shape); //0:all filled, 1:cleared
	
	var perc_inside = (inside_filled_count/points_in_shape); //0:none filled, 1:all filled
	
	//show_debug_message($"outside perc: {perc_outside}, inside perc: {perc_inside}, avg: {mean(perc_outside,perc_inside)}");
	
	var minperc = min(perc_inside,perc_outside);
	
	str.pass = minperc >= 0.85;
	str.label = $"{round(minperc*100)}%";
	
	//str.dist = abs(points_in_shape-pts);
	
	//str.pass = str.dist < max_pixel_difference;
	//var targdiff = 1 - str.dist/max_pixel_difference;
	
	////show_debug_message($"score: {pts}, shape: {points_in_shape}, diff: {str.dist}");
	
	//str.label = $"{round(targdiff*100)}";
	
	return str;
}


points_in_shape = 0;
shapearr = undefined;
point_inside_shape = function(px,py) {
	return shapearr[px][py] > 0;
}
calc_shape = function() {
	
	
	shapearr = array_create_2d(maxwid,maxhei);
	points_in_shape = 0;
	
	static qpos = function(xx,yy) {
		if shapearr[xx][yy]==0 {
			shapearr[xx][yy] = 1;
			queue_pos(xx,yy);
		}
	}
	
	//create edges
	var len = path_get_length(path);
	for(var i=0; i<len; i++) {
		var pos = i/len;
		var px = path_get_x(path,pos);
		var py = path_get_y(path,pos);
		px = floor(px);
		py = floor(py);
		if shapearr[px][py]==0 {
			shapearr[px][py] = 2;
			points_in_shape++
		}
	}
	
	//recurse, fill shape
	ds_stack_clear(checklistx);
	ds_stack_clear(checklisty);
	
	var cpos = get_centerpos();
	var cx = floor(cpos.x);
	var cy = floor(cpos.y);
	qpos(cx,cy);
	
	
	while(!ds_stack_empty(checklistx)) {
		
		var px = ds_stack_pop(checklistx);
		var py = ds_stack_pop(checklisty);
		
		shapearr[px][py] = 1;
		points_in_shape++
		
		qpos(px-1,py);
		qpos(px+1,py);
		qpos(px,py-1);
		qpos(px,py+1);
		
	}
	
	
}


calc_shape();




