

//text
//type

hovered = false;

scalex = image_xscale;
scaley = image_yscale;

dep_def = depth;

scale_def = 1;
scale_hov = 1.2;

scale = 1;
angle = 0;

ang_def = 0;
ang_hov = 15;

hov_amount = 0;


ftext = new fancytext();
ftext.fx_fadewave_in = false;
ftext.set_text(text);
ftext.set_centered();
ftext.set_scale(2);


set_size = function(wid,hei) {
	var spwid = sprite_get_width(sprite_index);
	var sphei = sprite_get_height(sprite_index);
	scalex = wid/spwid;
	scaley = hei/sphei;
}


is_gui = false;

draw = function() {
	draw_self();

	var tx = bbox_midx;
	var ty = bbox_midy;

	ftext.set_position(tx,ty);
	ftext.fx_waveamt = hov_amount*5;
	ftext.color = merge_color(COLORS.title_text_regular,COLORS.title_text_hover,hov_amount);

	ftext.draw();
}