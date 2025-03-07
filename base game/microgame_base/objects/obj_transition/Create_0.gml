

//halfway = false;

depth = depths.transition_obj;


surf = undefined;


timer = 0;

ttime = 30;

step = 1/40;

state = 0;

goesto = room;
onhalfway = do_nothing;
only_halfway = false;


percent = 0;


curve = animcurve_get_channel(ac_transition,0);

if halfway {
	percent = 1;
	state = 1;
}