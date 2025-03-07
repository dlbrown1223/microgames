

//type = ""
hovered = false;


if type=="win" {
	sprite_index = sp_button_win;
}
else if type=="lose" {
	sprite_index = sp_button_lose;
}

onclick = function() {
	
	if type=="win" {
		microgame_win();
	}
	else if type=="lose" {
		microgame_lose();
	}
	
}