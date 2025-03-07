// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function generate_coordinates(N) {

    var coords = [];
    var attempts = 0;
	var padding = 60
    
    while (array_length(coords) < N) {
        var new_x = irandom_range(padding, 480-padding); //[0,480]
        var new_y = irandom_range(padding, 270-padding); //[0,270]
        var valid = true;
        
        // Check if new coordinate is at least 20 pixels away from all others
        for (var i = 0; i < array_length(coords); i++) {
            var dx = new_x - coords[i][0];
            var dy = new_y - coords[i][1];
            if (sqrt(dx * dx + dy * dy) < 50) {
                valid = false;
                break;
            }
        }
        
        if (valid) {
            array_push(coords, [new_x, new_y]);
        }
        
        // Prevent infinite loops if N is too high
        attempts++;
        if (attempts > 1000) {
            break;
        }
    }
    
    return coords;
}