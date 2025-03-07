

function particle_get(pt_name) {
	return obj_game.particle_map[$ pt_name];
}

function pt_emit(xx,yy,pt_name,amt=1,rad=0) {
	
	var ptype = particle_get(pt_name);
	if !part_type_exists(ptype) {
		log("missing particle type",pt_name);
		return;
	}
	
	if amt<1 {
		if random(1)>amt return;
	}
	
	var px,py;
	repeat(ceil(amt)) {
		px = xx + random_range(-rad,rad);
		py = yy + random_range(-rad,rad);
		part_particles_create(obj_game.ps,px,py,ptype,1);
	}
	
}
