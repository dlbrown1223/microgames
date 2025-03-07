/// @description Insert description here
// You can write your code in this editor
time -= 1

if array_length(remaining_factors) <= 0 {
	win = true
	//
	microgame_win()
}

if time <= 0 {
	time = 0
	microgame_lose()
}