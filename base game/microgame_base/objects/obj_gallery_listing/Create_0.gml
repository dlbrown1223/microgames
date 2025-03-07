


text = new fancytext();
text.set_scale(1.5);
text.color = COLORS.title_text_regular;
text.fx_fadewave_in = false;

width = room_width*0.8;
height = 40;

hover = false;

game_struct = undefined;
title = "title";
author = "author";

set_position = function(_x,_y) {
	x = _x;
	y = _y;
	text.set_position(_x,_y);
}
update = function() {
	text.set_text($"{title}, by {author}");
}
onclick = function() {
	transition_to_basegame_individual(game_struct);
}
