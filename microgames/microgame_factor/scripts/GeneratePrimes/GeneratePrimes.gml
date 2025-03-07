// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function generate_prime_numbers(N) {
	var _primes = [2,  3,  5,  7, 11,   13,   17,   19,   23,  29]

// [2,  3,  5,  7, 11,   13,   17,   19,   23,   29
//,   31,   37,   41,   43,   47,   53,   59,   61,   67,   71
//,   73,   79,   83,   89,   97,  101,  103,  107,  109,  113
//,  179,  181,  191,  193,  197,  199,  211,  223,  227,  229
//,  283,  293,  307,  311,  313,  317,  331,  337,  347,  349
//,  419,  421,  431,  433,  439,  443,  449,  457,  461,  463
//,  547,  557,  563,  569,  571,  577,  587,  593,  599,  601
//,  661,  673,  677,  683,  691,  701,  709,  719,  727,  733
//,  811,  821,  823,  827,  829,  839,  853,  857,  859,  863]
	var _selected = []
	
	while (array_length(_selected) < N && array_length(_primes) > 0) {
	    var index = irandom_range(0, array_length(_primes) - 1);
	    array_push(_selected, _primes[index]);
	    array_delete(_primes, index, 1); // Delete from that index
	}
    
	return _selected;
}

