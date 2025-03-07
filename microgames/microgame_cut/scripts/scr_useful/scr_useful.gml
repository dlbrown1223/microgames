


function buffer_get_position_2d(xx,yy,wid,hei,bytes_per_pixel=4) {
	xx = floor(xx);
	yy = floor(yy);
	if xx<0 || yy<0 || xx>=wid || yy>=hei return -1;
	
	return (yy*wid + xx) * bytes_per_pixel;
}
function buffer_peek_2d(buff,xx,yy,wid,hei,type=buffer_u8) {
	var pos = buffer_get_position_2d(xx,yy,wid,hei);
	return buffer_peek(buff,pos,type);
}
function buffer_poke_2d(buff,xx,yy,wid,hei,val,type=buffer_u8) {
	var pos = buffer_get_position_2d(xx,yy,wid,hei);
	buffer_poke(buff,pos,type,val);
}


function buffer_seek_position(buff,xx,yy,wid,hei,bytes_per_pixel=4) {
	xx = floor(xx);
	yy = floor(yy);
	if xx<0 || yy<0 || xx>=wid || yy>=hei return false;
	
	var pos = (yy*wid + xx) * bytes_per_pixel;
	
	//buffer_poke(buff,pos,type,val);
	buffer_seek(buff,buffer_seek_start,pos);
	
	return true;
}

function buffer_setpixel(buff,xx,yy,wid,hei,color,alpha,check_changed=false) {
	if buffer_seek_position(buff,xx,yy,wid,hei) {
		
		
		var r = color_get_red(color);
		var g = color_get_green(color);
		var b = color_get_blue(color)
		var a = alpha*255;
		
		//skip setting if existing values are the same
		if check_changed {
			var pos = buffer_tell(buff);
			
			var r_cur = buffer_read(buff,buffer_u8);
			var g_cur = buffer_read(buff,buffer_u8);
			var b_cur = buffer_read(buff,buffer_u8);
			var a_cur = buffer_read(buff,buffer_u8);
			
			if r_cur==r && g_cur==g && b_cur==b && a_cur==a {
				return 0;
			}
			
			buffer_seek(buff,buffer_seek_start,pos);
		}
		
		buffer_write(buff,buffer_u8,r);
		buffer_write(buff,buffer_u8,g);
		buffer_write(buff,buffer_u8,b);
		buffer_write(buff,buffer_u8,a);
		return 1;
	}
	return 0;
}
function buffer_setpixel_circle(buff,xx,yy,surfwid,surfhei,rad,color,alpha,check_changed=false) {
	
	if !point_in_rectangle(xx,yy,-rad,-rad,surfwid+rad,surfhei+rad) {
		return 0;
	}
	
	var set_amt = 0;
	
	var x1 = xx-rad;
	var y1 = yy-rad;
	var x2 = xx+rad;
	var y2 = yy+rad;
	for(var px=x1; px<=x2; px++) {
		for(var py=y1; py<=y2; py++) {
			var dist = point_distance(px+0.5,py+0.5,xx,yy);
			if dist>rad continue;
			set_amt += buffer_setpixel(buff,px,py,surfwid,surfhei,color,alpha,check_changed);
		}
	}
	
	return set_amt;
}





function draw_path_dotted(path,xx,yy,dotsize,color,alpha=1,toggle=false,dotted=true) {
	
	var pcol = draw_get_color();
	var palph = draw_get_alpha();
	draw_set_color(color);
	draw_set_alpha(alpha);
	var len = path_get_length(path);
	
	var lx = path_get_x(path,0)+xx;
	var ly = path_get_y(path,0)+yy;
	for(var i=0; i<=len+dotsize; i+=dotsize) {
		var perc = i/len;
		
		var px = path_get_x(path,perc)+xx;
		var py = path_get_y(path,perc)+yy;
		
		if toggle || !dotted {
			draw_line(lx,ly,px,py);
		}
		toggle = !toggle;
		lx = px;
		ly = py;
	}
	
	draw_set_color(pcol);
	draw_set_alpha(palph);
	
}



function array_create_2d(wid,hei) {
	static str = { size: 0 };
	str.size = hei;
	return array_create_ext(wid,method(str,function(){
		return array_create(size);
	}));
}






















