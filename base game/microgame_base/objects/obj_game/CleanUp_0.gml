


network_destroy(socket);
buffer_delete(net_buff);
time_source_destroy_safe(ts_ping);

part_system_destroy(ps);

text_ann.cleanup();
text_score.cleanup();
text_gamespeed.cleanup();
text_paused.cleanup();
