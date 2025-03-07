/// @description Insert description here
// You can write your code in this editor
time -= 1

if times_teabagged >= times_needed {
	win = true
}

if time <= 0 {
	time = 0
	if win {
		microgame_win();
	}
	else {
		microgame_lose();
	}
}