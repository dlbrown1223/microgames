

var mouse_in_board = point_in_rectangle(mouse_x,mouse_y,boardx,boardy,boardx+maxwid*boardscale,boardy+maxhei*boardscale);

var cut_amount = 0;
if mouse_check_button(mb_left) && mouse_in_board {
	
	
	var rx = (mouse_x-boardx)/boardscale;
	var ry = (mouse_y-boardy)/boardscale;
	
	var set_amt = buffer_setpixel_circle(buff,rx,ry,maxwid,maxhei,brush_rad,c_black,0,true);
	if set_amt>0 {
		changed = true;
		checked = false;
		
		cut_amount = set_amt/10;
		
		var s = 3;
		repeat(set_amt) {
			var px = mouse_x+random_range(-s,s);
			var py = mouse_y+random_range(-s,s);
			part_particles_create(ps,px,py,pt_cardboard,1);
		}
	}
}



if mouse_check_button_released(mb_left) && !checked {
	check_board();
	checktimer = checktime;
}


checktimer--
if checktimer<=0 {
	
	if !checked {
		check_board();
	}
	
	checktimer = checktime;
}


//if keyboard_check_pressed(ord("S")) {
//	calc_score();
//}

if state==0 {
	if timer>0 {
		timer--
		if timer<=0 {
			timer = scoretime;
			state = 1;
			game_score = calc_score();
		}
	}
}
else {
	if timer>0 {
		timer--
		if timer<=0 {
			if game_score.pass {
				microgame_win();
			}
			else {
				microgame_lose();
			}
		}
	}
}


cut_amount = clamp(cut_amount,0,1);
cutvolume = lerp(cutvolume,cut_amount,0.2);

var gain = GAMEDATA.volume * cutvolume;
if cutsound==-1 {
	cutsound = audio_play_sound(snd_cut,0,true,gain);
}
audio_sound_gain(cutsound,gain,1);





	