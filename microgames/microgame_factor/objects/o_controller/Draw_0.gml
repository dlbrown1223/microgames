/// @description Insert description here
// You can write your code in this editor
draw_set_color(c_white);

draw_text(20, 20, string(time));

if (win) {
	draw_text(180, 20, string("passed!"));
}