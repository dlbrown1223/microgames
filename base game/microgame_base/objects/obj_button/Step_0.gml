


hovered = position_meeting(mouse_x,mouse_y,id) && !global.button_hovered;

if hovered {
	global.button_hovered = true;
}
depth = dep_def - hovered;

image_index = hovered;


image_xscale = scalex * scale;
image_yscale = scaley * scale;

image_angle = 0 + angle*15;

scale = lerp(scale,hovered ? scale_hov : scale_def,0.2);
angle = lerp(angle,hovered,0.2);

hov_amount = lerp(hov_amount,hovered,0.2);



if hovered && mouse_check_button_pressed(mb_left) {
	
	if type=="begin" {
		transition_to_basegame();
	}
	else if type=="gallery" {
		transition(rm_gallery);
	}
	else if type=="exit" {
		transition(undefined,game_end);
	}
	else if type=="pause_resume" {
		game_pause(false);
	}
	else if type=="pause_quit" {
		transition_out_of_basegame();
	}
}