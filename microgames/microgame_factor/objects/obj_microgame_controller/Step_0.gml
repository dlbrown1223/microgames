///@desc check connection


if _MICROGAME_DATA.is_setup {
	
	if last_packet_timer >= 60*2 {
		game_end(); //lost connection
	}
	last_packet_timer++
}

