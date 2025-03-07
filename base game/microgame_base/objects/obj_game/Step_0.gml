


fsm.step();


if !in_game {
	
	if !is_transitioning() && !PAUSED {
		if heart_count_timer<=0 {
			var targ = GAMEDATA.hearts;
			if hearts_display < targ {
				hearts_arr[hearts_display].increasing = true;
				hearts_display++
			}
			else if hearts_display > targ {
				hearts_display--
				hearts_arr[hearts_display].increasing = false;
			}
			heart_count_timer = heart_count_time;
		}
		else {
			heart_count_timer--
		}
	
		var len = alen(hearts_arr);
		for(var i=0; i<len; i++) {
			var heart = hearts_arr[i];
		
			heart.visible = hearts_display > i;
		
			var pprev = heart.percent;
			heart.percent = approach(heart.percent,heart.visible,1/30);
			if !heart.increasing && pprev>0 && heart.percent<=0 {
				var pos = game_heart_get_pos(i);
				pt_emit(pos.x,pos.y,"heart_break",20,5);
			}
		}
	}
	
	if keyboard_check_pressed(vk_escape) {
		game_pause(!PAUSED);
	}
}


pause_alph = lerp(pause_alph,PAUSED * 0.8, 0.2);


