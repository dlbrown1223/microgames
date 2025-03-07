

if !surface_exists(surf) {
	surf = surface_create(maxwid,maxhei);
	changed = true;
}
if !surface_exists(surf_preview) {
	surf_preview = surface_create(maxwid,maxhei);
}
if changed {
	buffer_set_surface(buff,surf,0);
	changed = false;
}



shader_set(shd_textured);
	texture_set_stage(u_texture,sprite_get_texture(sp_board_bottom,0));
	with obj_boardpiece { draw_bottom(); }
	texture_set_stage(u_texture,sprite_get_texture(sp_board_top,0));
	with obj_boardpiece { draw_top(); }
shader_reset();


surface_set_target(surf_preview);
	draw_clear_alpha(c_black,0);
	var toggle = round(0.5+sin(current_time/200)/2);
	//draw_path_dotted(path,0,0,2,#503030,1,toggle,false);
	draw_path_dotted(path,0,0,2,c_white,1,toggle);
	
	draw_circle((mouse_x-boardx)/boardscale-1,(mouse_y-boardy)/boardscale-1,brush_rad,true);
surface_reset_target();



gpu_set_tex_repeat(true);
shader_set(shd_textured);

	texture_set_stage(u_texture,sprite_get_texture(sp_board_bottom,0));
	draw_surface_ext(surf,boardx,boardy+1*boardscale, boardscale,boardscale, 0,c_white,1);
	draw_surface_ext(surf,boardx,boardy+2*boardscale, boardscale,boardscale, 0,c_white,1);

	texture_set_stage(u_texture,sprite_get_texture(sp_board_top,0));
	draw_surface_ext(surf,boardx,boardy, boardscale,boardscale, 0,c_white,1);

shader_reset();



if state==0 {
	var afade = 0.75+sin(current_time/200)/4;
	draw_surface_ext(surf_preview,boardx,boardy, boardscale,boardscale, 0,c_white,afade);
}


part_system_drawit(ps);


//for(var xx=0; xx<maxwid; xx++) {
//	for(var yy=0; yy<maxhei; yy++) {
//		draw_sprite_ext(sp_pixel,0,20+xx,40+yy,1,1,0,shapearr[xx][yy] ? c_red : c_lime,1)
//	}
//}




//var pos = current_time/600 % 1
//var px = path_get_x(path,pos)
//var py = path_get_y(path,pos)
//draw_circle(px,py,5,true)





if state==0 {
	//draw_text(20,20,$"TIME: {floor(timer/60)}s");
	var barh = 10;
	var perc = timer/maxtime;
	draw_rectangle(0,room_height-barh,room_width*perc,room_height,false);
}
else {
	draw_set_halign(fa_center);
	draw_set_color(game_score.pass ? c_lime : c_red);
	draw_text(centerx,20,$"Score: {game_score.label}");
	draw_set_color(c_white);
	draw_set_halign(fa_left);
}


