

randomize();

#macro GAMEDATA global._gamedata
function game_init() {
	
	
	GAMEDATA = {
		starttime: date_current_datetime(),
		hearts_max: 5,
		hearts: 5,
		gamespeed: 0, //percent speed, 0-1
		games_won: 0,
		points: 0,
		
		gamemode: GAMEMODES.normal,
		indiv_game_struct: undefined,
	};
	
	if is_struct(global.game_start_data) {
		struct_edit(GAMEDATA,global.game_start_data,true);
	}
	
	randomize();
	
	
}


function game_pause(state=true) {
	PAUSED = state;
	
	if state {
		
		with obj_game {
			on_pause();
		}
	}
	else {
		with obj_game {
			on_unpause();
		}
	}
}

global.game_start_data = undefined;
#macro GAMEMODES global._gamemodes
GAMEMODES = {
	normal: "normal",
	individual: "individual",
};

function transition_to_basegame_individual(game_struct) {
	transition_to_basegame({
		gamemode: GAMEMODES.individual,
		indiv_game_struct: game_struct,
	});
}
function transition_to_basegame(starting_data=undefined) {
	
	global.game_start_data = starting_data;
	
	var t = transition(rm_game);
}
function transition_out_of_basegame() {
	transition(rm_title);
}

function game_calculate_speed() {
	var spd = GAMEDATA.games_won;
	var games_per_speedup = 5;
	var speedups_per_game = 10;
	return clamp( floor(spd/games_per_speedup) / speedups_per_game, 0,1);
}

///sent to child game on setup
function game_get_setup_packet() {
	return {
		type: "setup",
		
		data: {
			gamespeed: GAMEDATA.gamespeed,
			do_fullscreen: window_get_fullscreen(),
			do_music: true,
			volume: SETTINGS.volume,
			
			window: {
				x: window_get_x(),
				y: window_get_y(),
				width: window_get_width(),
				height: window_get_height(),
			},
		},
	};
}

function game_set_announcement(text) {
	obj_game.text_ann.fade_text(text);
}
function game_draw_anouncement() {
	obj_game.text_ann.draw();
}


function game_score_add(amt) {
	GAMEDATA.points += amt;
	game_score_update();
	text_score.reset_fx();
}
function game_score_update() {
	text_score.change_text($"score: {GAMEDATA.points}");
}
function game_text_speed_update() {
	text_gamespeed.set_text($"speed: {round(GAMEDATA.gamespeed*100)}%");
}

///@desc returns a STATIC gui-space x,y struct
function game_heart_get_pos(index) {
	var cx = GUIWID/2;
	var cy = GUIHEI/2;
	
	var arr = obj_game.hearts_arr;
	var len = alen(arr);

	var spc = 50;
	var hx = cx - len * spc / 2 + spc/2;
	var hy = 50;
	
	static pos = { x: 0, y: 0 };
	
	pos.x = hx + index*spc;
	pos.y = hy;
	
	return pos;
}
function game_draw_hearts() {
	
	var arr = obj_game.hearts_arr;
	var len = alen(arr);

	var hang = sin(current_time/400)*10;
	
	static curve_incr = animcurve_get_channel(ac_heart_bounce,0);
	static curve_decr = animcurve_get_channel(ac_heart_bounce,1);

	for(var i=0; i<len; i++) {
		var heart = arr[i];
		
		var wavscale = 2 + sin(current_time/200 + i)*0.2;
		
		var curveperc = animcurve_channel_evaluate(heart.increasing ? curve_incr : curve_decr,clamp(heart.percent,0,1));
		var hsc = lerp(0,wavscale,curveperc);
		hsc = max(0,hsc);
		
		var pos = game_heart_get_pos(i);
		var hx = pos.x;
		var hy = pos.y;
		
		draw_sprite_ext(sp_heart,0,hx,hy,hsc,hsc,hang,c_white,1);
	}
}


function transition(goesto=undefined,onhalfway=do_nothing,only_halfway=false) {
	
	if is_transitioning() return noone;
	
	var t = instance_create_depth(0,0,0,obj_transition);
	t.goesto = goesto;
	t.onhalfway = onhalfway;
	t.only_halfway = only_halfway;
	
	return t;
}
function is_transitioning(_tolerance=0) {
	with obj_transition {
		if !(state==1 && percent<=_tolerance) {
			return true;
		}
		return true;
	}
}
function transition_out() {
	if is_transitioning() return noone;
	
	instance_create_depth(0,0,0,obj_transition,{ halfway: true });
}



#region game system

#macro GAME_NET_PORT 6510

#macro PATH_GAMES (game_included_directory() + "/games")

function gameloader_read_games() {
	
	log("=== game loader begin ===");
	
	GAMELOADER_DATA.games_array = [];
	
	//first, unzip
	var filenames = directory_get_filenames(PATH_GAMES);
	
	var len = alen(filenames);
	for(var i=0; i<len; i++) {
		var filename = filenames[i];
		
		//is file
		if string_contains(filename,".") {
			var filename_no_ext = string_split(filename,".")[0];
			if string_contains(filename,".zip") {
				
				var from_path = filepath_combine(PATH_GAMES,filename);		// "games/game.zip"
				var to_path = filepath_combine(PATH_GAMES,filename_no_ext); // "games/game"
				
				if directory_exists(to_path) {
					continue;
				}
				
				var status = zip_unzip(from_path,to_path);
				if status<0 {
					log($"{filename} unzip failure");
				}
				else {
					//file_delete(from_path);
				}
			}
			else {
				log($"unknown file type {filename}");
			}
		}
	}
	
	
	//load folders
	var foldernames = directory_get_filenames(PATH_GAMES,,,fa_directory); //does not detect empty folders
	var len = alen(foldernames);
	for(var i=0; i<len; i++) {
		var foldername = foldernames[i];
		gameloader_register_game(foldername);
	}
	
	GAMELOADER_DATA.games_array = array_shuffle(GAMELOADER_DATA.games_array);
	
	
	log("=== game loader finished ===");
}

function gameloader_register_game(foldername) {
	
	if !is_undefined(GAMELOADER_DATA.games_map[$ foldername]) {
		log($"conflict for game folder name {foldername}!");
		return;
	}
	
	var folderpath = filepath_combine(PATH_GAMES,foldername);
	
	var files_exe = directory_get_filenames(folderpath,".exe");
	var exe_count = alen(files_exe);
	if exe_count==0 {
		log($"no exe files found in {folderpath}!");
		return;
	}
	else if exe_count>1 {
		log($"multiple exe files found for {folderpath}!")
		return;
	}
	var file_exe = filepath_combine(folderpath,files_exe[0]);
	var file_metadata = filepath_combine(folderpath,"metadata.json");
	var metadata = {};
	
	var ctrl_sprite = sp_control_device;
	var ctrl_index = 2;
	
	//read metadata
	if file_exists(file_metadata) {
		try {
			//read json metadata
			metadata = json_load(file_metadata);
			
			//read controls string/array
			var ctrl_data = metadata[$ "controls"];
			if !is_undefined(ctrl_data) {
				var has_mouse = false;
				var has_keyboard = false;
				
				if is_array(ctrl_data) {
					has_mouse = array_contains(ctrl_data,"mouse");
					has_keyboard = array_contains(ctrl_data,"keyboard");
				}
				else if is_string(ctrl_data) {
					has_mouse = ctrl_data=="mouse";
					has_keyboard = ctrl_data=="keyboard";
				}
				
				if has_mouse && has_keyboard {
					ctrl_index = 2;
				}
				else if has_mouse {
					ctrl_index = 0;
				}
				else if has_keyboard {
					ctrl_index = 1;
				}
			}
			
		}
		catch(e) {
			log($"load error for {foldername}! {e}");
			return;
		}
	}
	
	var disabled = metadata[$ "disabled"];
	if !is_undefined(disabled) && disabled {
		return; //skip
	}
		
	var game_struct = {
		
		path_exe: file_exe,
		metadata,
		
		controls: { sprite: ctrl_sprite, index: ctrl_index },
	};
	
	
	
	GAMELOADER_DATA.games_map[$ foldername] = game_struct;
	array_push(GAMELOADER_DATA.games_array,game_struct);
	
}
function gamestruct_get_prompt(str) {
	var prompt = str.metadata[$ "prompt"] ?? "";
	return prompt=="" ? "Get ready..." : prompt;
}
function gamestruct_get_author(str) {
	return str.metadata[$ "author"] ?? "";
}

function gamesystem_load_game(struct) {
	var args = $"-microgame_uuid=\"{GAMELOADER_DATA.uuid}\" -microgame_port=\"{GAME_NET_PORT}\"";
	execute_shell_simple(struct.path_exe,args);
}
function gamesystem_start_game() {
	gamenet_send_packet({
		type: "start",
	});
}

#macro GAMELOADER_DATA global._gameloader_data
function gameloader_init() {
	
	GAMELOADER_DATA = {
		
		uuid: uuid_create(),
		
		games_array: [],
		games_map: {},
		
	};
	
	gameloader_read_games();
	
}




function gamenet_has_clients() {
	return alen(obj_game.client_array)>0;
}
function gamenet_send_packet(obj) {
	if !gamenet_has_clients() {
		log("packet send failed! no clients connected.");
	}
	var buff = obj_game.net_buff;
	
	obj[$ "uuid"] = GAMELOADER_DATA.uuid;
	obj[$ "to"] = "client";
	
	var jstr = json_stringify(obj);
	var bytesize = string_byte_length(jstr)+1;
	buffer_seek(buff,buffer_seek_start,0);
	var status = buffer_write(buff,buffer_string,jstr);
	if status!=0 {
		log("buffer_write error!");
	}
	
	var sock = obj_game.client_array[0].socket;
	
	network_send_packet(sock,buff,bytesize);
}


function gamenet_start_ping() {
	
	time_source_destroy_safe(ts_ping);
	
	pings_waiting = 0;
	ts_ping = time_source_create(time_source_global,1,time_source_units_seconds,function(){
		var ping_fail = !gamenet_has_clients() || pings_waiting>1;
		if ping_fail {
			if gamenet_has_clients() {
				gamenet_send_packet({ type: "close" }); //probably won't recieve it
			}
			game_ended_text = "Error!";
			GAMEDATA.hearts--
			fsm.change("game_ended");
			time_source_destroy_safe(ts_ping);
		}
		else {
			gamenet_send_packet({
				type: "ping",
			});
			pings_waiting++
		}
	},[],-1);
	time_source_start(ts_ping);
	
}


#endregion










