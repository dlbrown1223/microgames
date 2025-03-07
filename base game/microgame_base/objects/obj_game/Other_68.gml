		
var received_data = false;
var is_udp = false;
		
var n_id = async_load[? "id"];
if n_id==socket {
			
	var sock = async_load[? "socket"]; //connect/disconnect ONLY
	switch (async_load[? "type"]) {
				
				
		//got connection
		case network_type_connect:
		case network_type_non_blocking_connect:{
			
			var str = {
				socket: sock,
			};
			
			client_socket_map[$ sock] = str;
			array_push(client_array,str);
			
			gamenet_send_packet(game_get_setup_packet());
			
			gamenet_start_ping();
			
		}break;
		
		
		//got disconnect
		case network_type_disconnect:{
			var client = client_socket_map[$ sock];
			if is_struct(client) {
				array_remove(client_array,client);
				variable_struct_remove(client_socket_map,sock);
			}
		}break;
				
				
		case network_type_data:
			received_data = true;
			is_udp = true;
		break;
		
		
	}
	
}
//tcp data
else {
	received_data = true;
	is_udp = false;
}
		
//read data
if received_data {
	var clientfrom; //will be undefined before udp_setup
	if is_udp {
		//clientfrom = client_get_by_udp_port(async_load[? "port"]);
	}
	else {
		clientfrom = client_socket_map[$ async_load[? "id"]];
	}
	//try to parse json
	var buffer = async_load[? "buffer"];
	try {
		var jstr = buffer_peek(buffer, 0, buffer_string );
		var pack = json_parse(jstr);
	}
	catch(e) {
		log($"packet error! {e}");
		return;
	}
			
	receive_packet(pack,clientfrom);
}