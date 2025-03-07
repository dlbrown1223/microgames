


if state==0 {
	percent += step;
	if percent >= 1 {
		state = 1;
		if !is_undefined(goesto) {
			room_goto(goesto);
		}
		onhalfway();
		if only_halfway {
			instance_destroy();
		}
	}
}
else {
	percent -= step;
	if percent <= 0 {
		instance_destroy();
	}
}

