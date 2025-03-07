

hover = false;
if !global.button_hovered && point_in_rectangle( mouse_x,mouse_y, x,y, x+width,y+height ) {
	
	hover = true;
	
	global.button_hovered = true;
}




if hover {
	text.color = COLORS.title_text_hover;
	
	if mouse_check_button_pressed(mb_left) {
		onclick();
	}
}
else {
	text.color = COLORS.title_text_regular;
}