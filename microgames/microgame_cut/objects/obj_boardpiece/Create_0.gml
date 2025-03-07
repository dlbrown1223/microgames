


hsp = random_range(-1,1);
vsp = random_range(-1.5,-3);
spinspd = choose(-1,1)*random_range(2,4);
scale = 1;

draw_top = function(bottom=false) {
	
	var spr = sprite_index;
	var l = sprite_get_bbox_left(spr);
	var t = sprite_get_bbox_top(spr);
	var r = sprite_get_bbox_right(spr);
	var b = sprite_get_bbox_bottom(spr);
	
	var midx = l+(r-l)/2;
	var midy = t+(b-t)/2;
	
	var cdir = point_direction(0,0,midx,midy);
	var cdist = point_distance(0,0,midx,midy);
	
	var clx = lengthdir_x(cdist,cdir+image_angle)*scale;
	var cly = lengthdir_y(cdist,cdir+image_angle)*scale;
	
	var cornerx = x-clx;
	var cornery = y-cly;
	
	if bottom {
		cornerx += lengthdir_x(2*scale,image_angle-90);
		cornery += lengthdir_y(2*scale,image_angle-90);
	}
	
	draw_sprite_ext(
		sprite_index,image_index,cornerx,cornery,image_xscale,image_yscale,image_angle,image_blend,image_alpha
	)
	
}
draw_bottom = function() {
	draw_top(true);
}

