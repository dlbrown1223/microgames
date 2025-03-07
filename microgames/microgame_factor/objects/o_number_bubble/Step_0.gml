/// @description Insert description here
// You can write your code in this editor


// Reverse direction when hitting screen edges
if (bbox_left < 0 || bbox_right > room_width) {
    direction = 180 - direction; // Reflect horizontally
}
if (bbox_top < 0 || bbox_bottom > room_height) {
    direction = -direction; // Reflect vertically
}