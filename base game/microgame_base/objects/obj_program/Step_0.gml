


if keyboard_check_pressed(vk_f11) {
	fullscreen_toggle();
}

if DEBUG {
	if keyboard_check(vk_control) {
		
		if keyboard_check_pressed(ord("R")) {
			game_restart();
		}
	}
	
	if keyboard_check_pressed(192) { //~`
		debug_menu_open(!DEBUG_MENU.open);
	}
}

