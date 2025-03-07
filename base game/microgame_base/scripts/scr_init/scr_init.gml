


#macro VWID (1920/4)
#macro VHEI (1080/4)
#macro WINDOWSCALE 3
#macro GUIWID display_get_gui_width()
#macro GUIHEI display_get_gui_height()

window_set_size(VWID*WINDOWSCALE,VHEI*WINDOWSCALE);
window_center();

#macro SETTINGS global._settings
SETTINGS = {
	volume: 1,
};


#macro bbox_width (bbox_right-bbox_left)
#macro bbox_height (bbox_bottom-bbox_top)
#macro bbox_midx (bbox_left+bbox_width/2)
#macro bbox_midy (bbox_top+bbox_height/2)


#macro DEBUG false
#macro Debug:DEBUG true



enum depths {
	
	transition_obj = -100,
}