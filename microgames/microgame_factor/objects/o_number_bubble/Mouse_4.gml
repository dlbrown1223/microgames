/// @description Insert description here
// You can write your code in this editor

if (clickable) {
	
	var _child_1_coords = array_pop(o_controller.circle_coords)
	var _child_2_coords = array_pop(o_controller.circle_coords)	
	
	var _remaining = array_length(my_factors)
	
	// take a number of indexes from remaining factors
	var _indexes_to_take = irandom_range(1, _remaining-1)
	var _child_1_factors = []
	var _child_2_factors = []
	
	array_copy(_child_1_factors, 0, my_factors, 0, _indexes_to_take)
	array_copy(_child_2_factors, 0, my_factors, _indexes_to_take, _remaining-_indexes_to_take)
	
	show_debug_message("indexes to take" + string(_indexes_to_take))
	show_debug_message("_child_1_factors " + string(_child_1_factors))
	show_debug_message("_child_2_factors " + string(_child_2_factors))

	// create factor 1 and 2
	var _factor_1 = array_reduce(_child_1_factors, function(_acc, _val) { return _acc * _val; });
	var _factor_2 = my_number/_factor_1
	
	// create bubbles 
	var _bubble_1 = instance_create_depth(_child_1_coords[0], _child_1_coords[1],-100,o_number_bubble)
	_bubble_1.my_number = _factor_1
	_bubble_1.my_factors = _child_1_factors
	var _bubble_2 = instance_create_depth(_child_2_coords[0], _child_2_coords[1],-100,o_number_bubble)
	_bubble_2.my_number = _factor_2
	_bubble_2.my_factors = _child_2_factors

	// check to see if factor_1 is prime
	if (array_contains(o_controller.remaining_factors, _factor_1)){
		o_controller.remaining_factors = array_filter(o_controller.remaining_factors, 
		method({_factor_1: _factor_1}, function(_e) {return _e != _factor_1})) 
		_bubble_1.clickable = false
		_bubble_1.is_prime = true
	} else {
		_bubble_1.clickable = true
		_bubble_1.is_prime = false
	}
	
	// check to see if factor_2 is prime
	if (array_contains(o_controller.remaining_factors, _factor_2)){
		o_controller.remaining_factors = array_filter(o_controller.remaining_factors, 
		method({_factor_2: _factor_2}, function(_e) {return _e != _factor_2})) 
		_bubble_2.clickable = false
		_bubble_2.is_prime = true
	} else {
		_bubble_2.clickable = true
		_bubble_2.is_prime = false
	}
	
	clickable = false
}



