/// @description Insert description here
// You can write your code in this editors
draw_self()
draw_set_color(c_white);
draw_text(self.x+23, self.y+23, string(my_number));

if (o_controller.win & is_prime) {
	image_index=1
} else {
	image_index=0
}

