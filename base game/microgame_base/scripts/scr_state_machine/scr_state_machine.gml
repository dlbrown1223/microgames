


function state_machine(_parent_inst,_states) constructor {
	
	parent_inst = _parent_inst;
	states = _states;
	state = undefined;
	statename = "";
	timer = 0;
	state_lerp_in = 0;
	
	get_step_paused = return_false;
	
	static default_state = {
		step: do_nothing,
		enter: do_nothing,
		leave: do_nothing,
	};
	
	var names = struct_get_names(states);
	var nlen = alen(names);
	for(var i=0; i<nlen; i++) {
		var st = states[$ names[i]];
		struct_edit(st,variable_clone(default_state),false);
		struct_set_method_scope(st,parent_inst);
	}
	
	static get_statename = function() {
		return statename;
	}
	
	static change = function(name) {
		if !is_undefined(state) {
			state.leave();
		}
		statename = name;
		state = states[$ name];
		timer = 0;
		state_lerp_in = 0;
		state.enter();
	}
	
	static step = function() {
		
		if get_step_paused() return;
		if !is_struct(state) return;
		
		state_lerp_in = lerp(state_lerp_in,1,0.1);
		
		state.step();
		
		timer++
		
	}
}


