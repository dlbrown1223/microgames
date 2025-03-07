/*
*
* microgame system v1.0.0
* author: dan
*
*/

//hijack first room
room_goto(rm_microgame_waiting);


function _microgame_window_hide() {
	draw_enable_drawevent(false);
	window_command_run(window_command_minimize);
}
function _microgame_window_show() {
	draw_enable_drawevent(true);
	if MICROGAME_FULLSCREEN_ALLOWED && GAMEDATA.do_fullscreen {
		window_set_fullscreen(true);
	}
	else {
		window_command_run(window_command_restore);
		window_center();
		//resize window
		if MICROGAME_INHERITS_WINDOW_SIZE {
			var win = GAMEDATA.window;
			window_set_position(win.x,win.y);
			window_set_size(win.width,win.height);
		}
	}
}

#macro _MICROGAME_DATA global._microgame_data
_MICROGAME_DATA = {
	is_setup: false,
	connected: false,
	uuid: undefined,
	port: undefined,
	
	ended: false,
};


//read program parameters
var count = parameter_count();
for(var p=0; p<count; p++) {
	var param = parameter_string(p);
	if string_pos("-microgame",param)==0 continue;
	
	var value = string_split(param,"=")[1];
	
	if string_pos("-microgame_uuid",param)==1 {
		_MICROGAME_DATA.uuid = value;
	}
	else if string_pos("-microgame_port",param)==1 {
		_MICROGAME_DATA.port = real(value);
	}
}
_MICROGAME_DATA.is_setup = !is_undefined(_MICROGAME_DATA.uuid) && !is_undefined(_MICROGAME_DATA.port);

if _MICROGAME_DATA.is_setup {
	//hack to initialize immediately
	global.__window_command_hook_buffer = undefined;
	window_command_hook_prepare_buffer(64);
	window_command_hook_init();
	//hide window
	_microgame_window_hide();
}




