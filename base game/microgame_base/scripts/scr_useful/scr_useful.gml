



#macro alen array_length
#macro dsize ds_list_size
#macro dc draw_set_color
#macro da draw_set_alpha


function fullscreen_toggle() {
	var state = !window_get_fullscreen();
	if state {
		window_enable_borderless_fullscreen(true);
	}
	window_set_fullscreen(state);
}

function do_nothing(){}
function does_something(val) {
	return is_callable(val) && val!=do_nothing;
}
function return_false(){ return false; }
function return_true(){ return true; }


function log() {
	var s = "";
	for(var i=0; i<argument_count; i++) {
		s += string(argument[i]);
		if i<argument_count-1 {
			s += ",";
		}
	}
	show_debug_message(s);
}

function animcurve_eval_clamped(channel,pos) {
	return animcurve_channel_evaluate(channel,clamp(pos,0,1));
}



function game_files_directory() {
	//local appdata saved files
	//return working_directory;
	return game_save_id;
}
function game_included_directory() {
	//included files
	return working_directory;
}

function directory_get_filenames(dirname,extension_with_dot="",remove_extension=false,attr=fa_none) {
	
	
	var arr = [];
	if directory_exists(dirname) {
		

		var fname = file_find_first($"{dirname}/*{extension_with_dot}",attr);
		while (fname!="") {
			array_push(arr,fname);
			fname = file_find_next();
		}
		file_find_close();
		
		//exclude filenames with dots
		if attr==fa_directory {
			arr = array_filter(arr,function(name){
				return !string_contains(name,".");
			});
		}
		if remove_extension {
			arr = array_map(arr,function(name){
				return string_split(filename_name(name),".")[0];
			});
		}
		
	}
	
	return arr;
}
///@func filepath_combine()
function filepath_combine() {
	var str = "";
	
	for(var i=0; i<argument_count; i++) {
		var arg = argument[i];
		
		var c = string_char_last(arg);
		while (c=="/" || c=="\\") {
			arg = string_delete(arg,string_length(arg),1);
			c = string_char_last(arg);
		}
		
		if arg!="" {
			if i>0 {
				str += "/";
			}
			str += arg;
		}
	}
	
	return str;
}




function json_save(struct,filename,pretty=false) {
	
	var jstr = json_stringify(struct,pretty);
	var bsize = string_byte_length(jstr)+1;
	var buff = buffer_create(bsize,buffer_fixed,1);
	buffer_write(buff,buffer_string,jstr);
	buffer_delete(buff);
	
}
function json_load(fname) {
	var buff = buffer_load(fname);
	var jstr = buffer_peek(buff,0,buffer_string);
	buffer_delete(buff);
	return json_parse(jstr);
}



function string_contains(str,sub) {
	return string_pos(sub,str)!=0;
}
function string_char_last(str) {
	return string_char_at(str,string_length(str));
}

function time_source_destroy_safe(ts,destroyTree=undefined) {
	if time_source_exists(ts) {
		time_source_destroy(ts,destroyTree);
	}
}

function array_random(arr) {
	return arr[irandom(alen(arr)-1)];
}

///@desc does not recurse!!
function struct_edit(obj,objfrom,replace=true) {
	var names = struct_get_names(objfrom);
	var len = alen(names);
	var name,val,fromval;
	for(var i=0; i<len; i++) {
		name = names[i];
		fromval = objfrom[$ name];
		if variable_struct_exists(obj,name) && !replace {
			continue;
		}
		obj[$ name] = fromval;
	}
	return obj;
}


///@desc not recursive!
function struct_set_method_scope(str,scope) {
	var names = struct_get_names(str);
	var len = alen(names);
	for(var i=0; i<len; i++) {
		var name = names[i];
		var val = str[$ name];
		if is_method(val) {
			str[$ name] = method(scope,val);
		}
	}
}

function array_remove(arr,val) {
	var ind = array_get_index(arr,val);
	if ind!=-1 {
		array_delete(arr,ind,1);
	}
}



function uuid_create() {
	var str = md5_string_unicode($"{get_timer()},{date_current_datetime()},{random(2_000_000)}");
	str = string_replace_all(str," ","");
	return str;
}



function shader_set_uniform_color(uniform,color) {	
	shader_set_uniform_f(uniform,color_get_red(color)/255,color_get_green(color)/255,color_get_blue(color)/255);
}




function remap(val,low1,up1,low2,up2) {
	return (val - low1) / (up1 - low1) * (up2 - low2) + low2; 
}
function remap_clamped(val,low1,up1,low2,up2) {
	return clamp((val - low1) / (up1 - low1) * (up2 - low2) + low2,low2,up2); 
}
function approach(val,targ,amt) {
	if (val < targ)
	    return min(val + amt, targ); 
	else
	    return max(val - amt, targ);
}

