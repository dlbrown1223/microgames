

var scr = mouse_wheel_down()-mouse_wheel_up();
if scr!=0 {
	scrolltarg -= scr*25;
}

scrolltarg = clamp(scrolltarg,-scrollmax,0);


scroll = lerp(scroll,scrolltarg,0.1);


with obj_gallery_listing {
	set_position(xstart,ystart+other.scroll);
}

text_title.set_position(room_width/2,60+scroll);

