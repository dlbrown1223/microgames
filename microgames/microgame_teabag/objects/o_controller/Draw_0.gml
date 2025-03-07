/// @description Insert description here
// You can write your code in this editor


draw_set_color(c_white);

draw_text(20, 20, $"timer: {floor(time/60)}s\nleft: {max(0,times_needed-times_teabagged)}");


if (win) {
	draw_text(180, 20, string("passed!"));
}