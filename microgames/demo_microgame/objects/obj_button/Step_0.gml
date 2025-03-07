

hovered = position_meeting(mouse_x,mouse_y,id);

image_index = hovered;


if hovered && mouse_check_button_pressed(mb_left) {
	onclick();
}