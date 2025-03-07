/*
*
* microgame system v1.0.0
* author: dan
*
* These are functions you should use in your microgame!
*
*/



///@desc call this to win the microgame and close the window
function microgame_win() {
	if !_MICROGAME_DATA.is_setup {
		game_end();
	}
	if _MICROGAME_DATA.ended || !_MICROGAME_DATA.connected {
		return;
	}
	_MICROGAME_DATA.ended = true;
	obj_microgame_controller.send_packet({
		type: "win",
	});
}
///@desc call this to lose the microgame and close the window
function microgame_lose() {
	if !_MICROGAME_DATA.is_setup {
		game_end();
	}
	if _MICROGAME_DATA.ended || !_MICROGAME_DATA.connected {
		return;
	}
	_MICROGAME_DATA.ended = true;
	obj_microgame_controller.send_packet({
		type: "lose",
	});
}

///@desc returns a number for the percent speed of the game. 0=default speed, 1=max speed
function microgame_get_gamespeed() {
	return GAMEDATA.gamespeed;
}

///@desc only play music if this is true. 
///this is so the base game may play music over a microgame at some point
function microgame_get_music_enabled() {
	return GAMEDATA.do_music;
}
///@desc multiply the gain of all your sounds by this value. 
///this is so the base game can control the volume of any microgame.
function microgame_get_volume() {
	return GAMEDATA.volume;
}





