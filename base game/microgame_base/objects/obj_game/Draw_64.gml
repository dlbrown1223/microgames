

if !in_game {
	
	if has_games {
		text_score.draw();
		text_gamespeed.draw();

		game_draw_hearts();
	}

	game_draw_anouncement();
	
	
	if fsm.statename=="nextgame" {
		
		var cx = GUIWID/2;
		var cy = GUIHEI/2;
		
		if game_author!="" {
			da(fsm.state_lerp_in);
			dc(COLORS.title_text_regular);
			dtext(cx,cy+55,game_author,1,true);
			da(1);
			dc(c_white);
		}
		
		//controls icon
		var sc = 1.5;
		var ctrl = game_struct.controls;
		draw_sprite_ext(ctrl.sprite,ctrl.index,cx,cy+100, sc,sc, 0,c_white,fsm.state_lerp_in);
		

	}

}
else {
	draw_clear(c_black);
	
	
	//if DEBUG {
	//	dc(#2c2a46);
	//	dtext(20,20,$"connected{string_repeat(".",pings_waiting)}",1);
	//	dc(c_white);
	//}
}


if paused {
	da(pause_alph);
	dc(c_black);
	draw_rectangle(0,0,GUIWID,GUIHEI,false);
	dc(c_white);
	da(1);
	
	text_paused.draw();
}



