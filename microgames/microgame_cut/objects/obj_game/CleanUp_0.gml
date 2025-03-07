

surface_free(surf);
surface_free(surf_preview);
surface_free(surf_sprite);
buffer_delete(buff);
buffer_delete(buff_group);
part_system_destroy(ps);
ds_stack_destroy(checklistx);
ds_stack_destroy(checklisty);
ds_list_destroy(group_pixel_counts);

if cutsound!=-1 {
	audio_stop_sound(cutsound);
}
