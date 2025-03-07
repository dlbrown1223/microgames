

#macro DEBUG_MENU global._debug_menu
DEBUG_MENU = {
	open: false,
	view: undefined,
};

function debug_menu_open(state=true) {
	
	DEBUG_MENU.open = state;
	if state {
		DEBUG_MENU.view = dbg_view("debug menu",true);
	}
	else {
		show_debug_overlay(false);
		dbg_view_delete(DEBUG_MENU.view);
		DEBUG_MENU.view = undefined;
	}
	
	
}


