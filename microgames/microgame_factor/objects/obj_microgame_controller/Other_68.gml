

var n_id = async_load[? "id"];
if n_id==socket {
	
	switch (async_load[? "type"]) {
		
		case network_type_data:{
			var buffer = async_load[? "buffer"];
			try {
				var jstr = buffer_peek(buffer, 0, buffer_string );
				show_debug_message($"got jstr: \"{jstr}\"")
				var pack = json_parse(jstr);
			}
			catch(e) {
				show_debug_message($"invalid packet: {e}");
				return;
			}
			receive_packet(pack);
		}break;
		
		case network_type_non_blocking_connect:{
			if async_load[? "socket"]==socket {
				if async_load[? "succeeded"] {
					on_connected();
				}
				else {
					on_connect_failed();
				}
			}
		}break;
		
		case network_type_disconnect:{
			if async_load[? "socket"]==socket {
				on_disconnected();
			}
		}break;
		
	}
			
}

