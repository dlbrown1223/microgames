

buffer_delete(net_buffer);
if !is_undefined(socket) {
	network_destroy(socket);
}

