// Factorization Game
time = 1000
win = false


factors_to_generate = 5
randomize();
remaining_factors = generate_prime_numbers(factors_to_generate)

circle_coords = generate_coordinates(30)

// Create first instance
var _coords1 = array_pop(circle_coords)
firstobj = instance_create_depth(_coords1[0], _coords1[1], -2, o_number_bubble)

firstobj.my_number = array_reduce(remaining_factors, function(_acc, _val) { return _acc * _val; });
firstobj.my_factors = []
array_copy(firstobj.my_factors, 0, remaining_factors, 0, array_length(remaining_factors))
firstobj.is_prime = false
firstobj.clickable = true




