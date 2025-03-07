

if is_undefined(surf) || !surface_exists(surf) {
	surf = surface_create(GUIWID,GUIHEI);
}


surface_set_target(surf);
draw_clear(c_black);

gpu_set_blendmode(bm_subtract);
var cx = GUIWID/2;
var cy = GUIHEI/2;

var perc = clamp(percent,0,1);

perc = animcurve_channel_evaluate(curve,perc);

var dist = point_distance(0,0,cx,cy) * (1-perc);



draw_circle(cx,cy,dist,false);

gpu_set_blendmode(bm_normal);

surface_reset_target();


draw_surface_stretched(surf,0,0,GUIWID,GUIHEI);

