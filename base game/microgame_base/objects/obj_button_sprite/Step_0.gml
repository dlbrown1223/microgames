

image_index = 0;
if !global.button_hovered && position_meeting(mouse_x,mouse_y,id) {
	
	image_index = 1;
	
	if mouse_check_button_pressed(mb_left) {
		onclick();
	}
	
	global.button_hovered = true;
}

