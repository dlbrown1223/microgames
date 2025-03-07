/*
* These are settings for your game specifically.
*/

///whether fullscreen is allowed (matches base game fullscreen)
#macro MICROGAME_FULLSCREEN_ALLOWED true

///whether the game window will scale to match the size of the base game
#macro MICROGAME_INHERITS_WINDOW_SIZE true


///@desc This is called automatically when the gameplay begins. 
///If you have 1 room, it will work. But make sure it goes to the correct room! 
///you can just change this whole thing to room_goto(rm_game)
function microgame_on_start() {
	var checkroom = room_first;
	while(checkroom == rm_microgame_waiting) {
		checkroom = room_next(checkroom);
	}
	if room_exists(checkroom) {
		room_goto(checkroom);
	}
}

