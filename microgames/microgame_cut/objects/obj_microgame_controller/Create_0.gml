


if instance_number(object_index)>1 {
	instance_destroy();
	exit;
}


//data received from base game
#macro GAMEDATA global._gamedata
GAMEDATA = {
	gamespeed: 0, //percent speed, 0-1
	do_fullscreen: false,
	do_music: true,
	volume: 1,
	window: undefined, //window size struct
};



#region networking
socket = undefined;
net_buffer = buffer_create(64,buffer_grow,1);

if _MICROGAME_DATA.is_setup {
	
	socket = network_create_socket(network_socket_tcp);
	if socket<0 {
		throw "socket create failed!";
	}
	network_connect_async(socket,"127.0.0.1",_MICROGAME_DATA.port);
}
else {
	microgame_on_start(); //started normally, just enter game
}

last_packet_timer = 0;
started = false;
on_connected = function() {
	_MICROGAME_DATA.connected = true;
}
on_connect_failed = function() {
	
}
on_disconnected = function() {
	_MICROGAME_DATA.connected = false;
}
receive_packet = function(pack) {
	if pack[$ "uuid"]!=_MICROGAME_DATA.uuid || pack[$ "to"]!="client" {
		return; //not for us
	}
	
	last_packet_timer = 0;
	
	switch(pack[$ "type"]) {
		case "setup":{
			GAMEDATA = pack.data;
		}break;
		
		case "start":{
			started = true;
			microgame_on_start();
			_microgame_window_show();
		}break;
		
		case "close":{
			game_end();
		}break;
		
		case "ping":{
			send_packet({
				type: "pong",
			});
		}break;
	}
}

send_packet = function(obj) {
	
	obj[$ "uuid"] = _MICROGAME_DATA.uuid;
	obj[$ "to"] = "server";
	
	var jstr = json_stringify(obj);
	var bytesize = string_byte_length(jstr)+1;
	buffer_seek(net_buffer,buffer_seek_start,0);
	buffer_write(net_buffer,buffer_string,jstr);
	
	show_debug_message($"sending {jstr}")
	
	network_send_packet(socket,net_buffer,bytesize);
}



#endregion
