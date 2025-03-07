

#macro TEXTSCALE (1/2)

function init_drawing() {
	draw_set_font(fnt_default);
	gpu_set_tex_repeat(true);
}

function dtext(_x,_y,text,scale,center=false,angle=0) {
	if center {
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		//_x -= dtext_width(text,scale);
		//_y -= dtext_height(text,scale);
	}
	scale *= TEXTSCALE;
	draw_text_transformed(_x,_y,text,scale,scale,angle)
	if center {
		draw_set_halign(fa_left)
		draw_set_valign(fa_top)
	}
}

function dtext_width(str,scale=1) {
	scale *= TEXTSCALE;
	return string_width(str)*scale;
}
function dtext_height(str,scale=1) {
	scale *= TEXTSCALE;
	return string_height(str)*scale;
}





function _fancychar(_char,_index,_parent) constructor {
	
	char = _char;
	alpha = 1;
	scale = 1;
	
	xoff = 0;
	yoff = 0;
	
	parent = _parent;
	index = _index;
	age = 0;
	
	color = undefined;
	angle = 0;
	
	if parent.fx_fadewave_in {
		alpha = -index * 0.5;
		curve = animcurve_get_channel(ac_text_announce,0);
	}
	
	static change = function(_char) {
		char = _char;
	}
	
	static step = function() {
		
		var _yoff = 0;
		
		if parent.fx_fadeout {
			alpha = approach(alpha,0,1/10);
			_yoff += approach(yoff,10,1);
		}
		else if parent.fx_fadewave_in {
			alpha = approach(alpha,1,1/7);
			
			var in_perc_move = clamp((age-index*4)/60,0,1);
			var in_perc_color = clamp((age-index*4)/15,0,1);
			var in_perc_angle = 1-clamp((age-index*4)/15,0,1);
			
			_yoff += animcurve_channel_evaluate(curve,in_perc_move) * 13;
			
			color = merge_color(c_white,parent.color,in_perc_color);
			
			angle = in_perc_angle * -10;
		}
		
		if parent.fx_waveamt != 0 {
			_yoff += sin(current_time/300 + index*0.6) * parent.fx_waveamt;
		}
		
		yoff = _yoff;
		
		
		age++
	}
	
	static get_width = function() {
		return dtext_width(char,scale*parent.scale);
	}
	static get_height = function() {
		return dtext_height(char,scale*parent.scale);
	}
	
}
function fancytext() constructor {
	
	
	list = ds_list_create();
	targ_text = "";
	next_text = "";
	
	scale = 2;
	x = 0;
	y = 0;
	halign = fa_left;
	valign = fa_top;
	
	color = COLORS.title_text_hover;
	do_drop_shadow = true;
	color_bg = COLORS.title_text_bg;
	
	fx_fadewave_in = true;
	fx_fadeout = false;
	fx_waveamt = 0;
	fadeout_percent = 0;
	
	static fade_text = function(str) {
		if targ_text=="" {
			set_text(str);
		}
		else {
			next_text = str;
			set_text("");
		}
	}
	static change_text = function(str) {
		var len = string_length(str);
		var listsize = dsize(list);
		if listsize<len {
			var i = 0;
			repeat(len-listsize) {
				ds_list_add(list,new _fancychar("",listsize+i++,self));
			}
		}
		
		for(var i=0; i<len; i++) {
			var charstr = list[| i];
			charstr.change(string_char_at(str,i+1));
		}
	}
	static set_text = function(str) {
		
		fadeout_percent = 0;
		
		if str=="" && targ_text!="" {
			fx_fadeout = true;
		}
		else {
			targ_text = str;
			var len = string_length(str);
			ds_list_clear(list);
			for(var i=0; i<len; i++) {
				var char = string_char_at(str,i+1);
				var charstr = new _fancychar(char,i,self);
				ds_list_add(list,charstr);
			}
			fx_fadeout = false;
		}
		
	}
	
	static reset_fx = function() {
		var len = dsize(list);
		for(var i=0; i<len; i++) {
			var charstr = list[| i];
			charstr.age = 0;
		}
	}
	
	static set_position = function(_x,_y) {
		x = _x;
		y = _y;
	}
	static set_scale = function(_scale) {
		scale = _scale;
	}
	static set_centered = function() {
		halign = fa_center;
		valign = fa_middle;
	}
	
	static draw = function() {
		
		var tx = x;
		var ty = y;
		
		var wid = get_width();
		var hei = get_height();
		
		if halign==fa_center {
			tx -= wid/2;
		}
		else if halign==fa_right {
			tx -= wid;
		}
		if valign==fa_middle {
			ty -= hei/2;
		}
		else if halign==fa_bottom {
			ty -= hei;
		}
		
		
		
		
		
		//step chars		
		var len = dsize(list);
		for(var i=0; i<len; i++) {
			var charstr = list[| i];
			charstr.step();
		}
		
		///draw
		if do_drop_shadow {
			dc(color_bg);
			var dx = tx;
			var dy = ty + 4;
			for(var i=0; i<len; i++) {
				var charstr = list[| i];
				da(charstr.alpha);
				dtext(dx+charstr.xoff,dy+charstr.yoff,charstr.char,scale*charstr.scale,false,charstr.angle);
				dx += charstr.get_width();
			}
		}
		dc(color);
		var dx = tx;
		var dy = ty;
		for(var i=0; i<len; i++) {
			var charstr = list[| i];
			da(charstr.alpha);
			dc( is_undefined(charstr.color) ? color : charstr.color );
			dtext(dx+charstr.xoff,dy+charstr.yoff,charstr.char,scale*charstr.scale,false,charstr.angle);
			dx += charstr.get_width();
		}
		dc(c_white);
		da(1);
		
		
		//step fx
		if fx_fadeout {
			fadeout_percent = approach(fadeout_percent,1,1/40);
			if fadeout_percent==1 && next_text!="" {
				set_text(next_text);
				next_text = "";
			}
		}
		
	}
	
	static get_width = function() {
		return dtext_width(targ_text,scale);
	}
	static get_height = function() {
		return dtext_height(targ_text,scale);
	}
	
	
	static cleanup = function() {
		ds_list_destroy(list);
	}
	
}




