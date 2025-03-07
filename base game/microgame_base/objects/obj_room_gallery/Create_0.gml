


var lay = layer_get_id("Background");
if layer_exists(lay) layer_set_visible(lay,false);



scroll = 0;
scrolltarg = 0;

game_arr = GAMELOADER_DATA.games_array;
game_count = alen(game_arr);

text_title = new fancytext();
text_title.fx_fadewave_in = false;
text_title.set_text("Gallery");
text_title.set_centered();

var vspc = 50;
var brd = 50;
var dx = brd;
var dy = 100;

scrollmax = game_count * vspc - vspc;

var elem;
for(var i=0; i<game_count; i++) {
	elem = game_arr[i];
	
	var inst = instance_create_depth(dx,dy,0,obj_gallery_listing);
	inst.title = gamestruct_get_prompt(elem);
	inst.author = gamestruct_get_author(elem);
	inst.game_struct = elem;
	inst.update();
	
	dy += vspc;
}


var brd = 25;
var backbutton = instance_create_depth(brd,brd,0,obj_button_sprite);
with backbutton {
	is_gui = true;
	sprite_index = sp_button_back;
	var sc = 1.5;
	image_xscale = sc;
	image_yscale = sc;
	onclick = function() {
		transition(rm_title);
	};
}
