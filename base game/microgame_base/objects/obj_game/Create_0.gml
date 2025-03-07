

game_init();


#region ui

text_ann = new fancytext();
text_ann.set_position(GUIWID/2,GUIHEI/2);
text_ann.set_centered();

text_score = new fancytext();
text_score.set_position(20,20);
text_score.set_scale(1);
text_score.color = COLORS.text_score;
game_score_update();

text_gamespeed = new fancytext();
text_gamespeed.set_position(20,40);
text_gamespeed.set_scale(1);
text_gamespeed.color = COLORS.text_score;
game_text_speed_update();

///pause screen
var cx = GUIWID/2;
var cy = 40;
var cspc = 40;
text_paused = new fancytext();
text_paused.set_position(cx,cy);
text_paused.set_centered();
var bwid = 100;
var bhei = 30;
cy += 60;
button_pause_resume = instance_create_depth(cx,cy,0,obj_button,{ type: "pause_resume", text: "resume", depth: depth-1 });
button_pause_resume.set_size(bwid,bhei);
button_pause_resume.is_gui = true;
cy += 50;
button_pause_quit = instance_create_depth(cx,cy,0,obj_button,{ type: "pause_quit", text: "quit", depth: depth-1 });
button_pause_quit.set_size(bwid,bhei);
button_pause_quit.is_gui = true;

pause_alph = 0;

on_pause = function() {
	text_paused.set_text("Paused");
	
	instance_activate_object(button_pause_resume);
	instance_activate_object(button_pause_quit);
}
on_unpause = function() {
	
	instance_deactivate_object(button_pause_resume);
	instance_deactivate_object(button_pause_quit);
}
on_unpause();

#endregion


paused = false;
#macro PAUSED obj_game.paused

new_points = 0;
targ_gamespeed = GAMEDATA.gamespeed;

in_game = false;
game_name = "";
game_struct = undefined;
game_prompt = "";
game_author = "";
has_games = alen(GAMELOADER_DATA.games_array)>0;
game_index = -1;

hearts_display = 0;
hearts_arr = array_create_ext(GAMEDATA.hearts_max,function(){
	return {
		visible: false,
		percent: 0,
		increasing: true,
	};
});
heart_count_timer = 0;
heart_count_time = 20;

#region particles
ps = part_system_create();
particle_map = {};

var p = part_type_create();
particle_map[$ "heart_break"] = p;
part_type_sprite(p,sp_pixel,0,0,0);
part_type_direction(p,0,360,0,0);
part_type_orientation(p,0,360,0,0,0);
part_type_size(p,0.8,1,0,0);
part_type_life(p,30,60);
part_type_color1(p,#D31212);
part_type_alpha3(p,1,1,0);
part_type_speed(p,2,3,-0.033,0);
part_type_scale(p,4,4);
part_type_gravity(p,0.03,270)


#endregion

#region networking

socket = network_create_server(network_socket_tcp,GAME_NET_PORT,1);
if socket<0 {
	throw "socket create failed!";
}
net_buff = buffer_create(64,buffer_grow,1);

client_socket_map = {};
client_array = [];
ts_ping = undefined;
last_pong = undefined;
pings_waiting = 0;

game_ended_text = "";



receive_packet = function(pack,clientfrom) {
	if pack[$ "uuid"]!=GAMELOADER_DATA.uuid || pack[$ "to"]!="server" {
		return; //not for us
	}
	
	switch(pack[$ "type"]) {
		
		case "win":{
			gamenet_send_packet({
				type: "close",
			});
			
			game_ended_text = "You win!";
			
			new_points += 10;
			GAMEDATA.games_won++
			
			fsm.change("game_ended");
		}break;
		
		case "lose":{
			gamenet_send_packet({
				type: "close",
			});
			
			GAMEDATA.hearts--
			
			game_ended_text = "You lose!";
			
			fsm.change("game_ended");
		}break;
		
		case "pong":{
			pings_waiting = 0;
		}break;
	}
	
}

#endregion


#region state machine

on_game_error = function() {
	game_ended_text = "Error!";
	fsm.change("game_ended");
}


fsm = new state_machine(id,{

	nextgame: {
		
		enter: function(){
			
			if !window_has_focus() || os_is_paused() {
				game_pause(true);
			}
			
			if GAMEDATA.gamemode == GAMEMODES.normal {
				//choose random non-repeating game
				
				var gamecount = alen(GAMELOADER_DATA.games_array);
				if game_index>=gamecount-1 {
					game_index = -1;
				}
				else {
					game_index++
				}
				if game_index==-1 {
					GAMELOADER_DATA.games_array = array_shuffle(GAMELOADER_DATA.games_array);
					//avoid repeating
					if gamecount > 1 && is_struct(game_struct) {
						while(GAMELOADER_DATA.games_array[0]==game_struct) {
							GAMELOADER_DATA.games_array = array_shuffle(GAMELOADER_DATA.games_array);
						}
					}
					game_index = 0;
				}
				game_struct = GAMELOADER_DATA.games_array[game_index];
			}
			else if GAMEDATA.gamemode == GAMEMODES.individual {
				//repeat individual game
				
				game_struct = GAMEDATA.indiv_game_struct;
			}
			game_prompt = gamestruct_get_prompt(game_struct);
			game_author = gamestruct_get_author(game_struct);
			
			gamesystem_load_game(game_struct);
			
			game_set_announcement(game_prompt);
		},
		step: function(){
			
			var begintime = 60*1.5;
			if fsm.timer==begintime {
				
				if gamenet_has_clients() {
					transition(undefined,function(){
						with obj_game {
							fsm.change("ingame");
						}
					},true);
				}
				else {
					on_game_error();
				}
			}
			
		},
	},
	
	game_ended: {
		enter: function(){
			transition_out();
			
			if !has_games {
				game_ended_text = "no games :(";
			}
			game_set_announcement(game_ended_text);
		},
		step: function(){
			
			//after game, count score
			if !is_transitioning(0.1) {
				if new_points>0 {
					game_score_add(new_points);
					new_points = 0;
				}
			}
			
			var statetime = 60*2.5;
			if fsm.timer >= statetime {
				
				if !has_games {
					transition(rm_title);
					return;
				}
				
				//don't do anything until hearts counted
				if hearts_display!=GAMEDATA.hearts || is_transitioning() {
					return;
				}
				
				if GAMEDATA.hearts<=0 {
					fsm.change("game_lost");
				}
				else {
					targ_gamespeed = game_calculate_speed();
					if targ_gamespeed != GAMEDATA.gamespeed {
						fsm.change("speedup");
					}
					else {
						fsm.change("nextgame");
					}
				}
			}
			
		},
	},
	
	speedup: {
		enter: function(){
			game_set_announcement("Speed up!");
			GAMEDATA.gamespeed = targ_gamespeed;
			game_text_speed_update();
		},
		step: function(){
			
			//var stepamt = (1/10)/60;
			//GAMEDATA.gamespeed = approach(GAMEDATA.gamespeed,targ_gamespeed,stepamt);
			//GAMEDATA.gamespeed = lerp(GAMEDATA.gamespeed,targ_gamespeed,0.1);
			
			var statetime = 60*2.5;
			if /*GAMEDATA.gamespeed == targ_gamespeed &&*/ fsm.timer >= statetime {
				fsm.change("nextgame");
			}
		},
		leave: function() {
			
		},
	},
	
	game_lost: {
		enter: function() {
			game_set_announcement("Game Over!");
		},
		step: function() {
			var statetime = 60*3;
			if fsm.timer == statetime {
				transition(rm_title);
			}
		},
	},
	
	ingame: {
		
		enter: function() {
			if !gamenet_has_clients() {
				on_game_error();
				return;
			}
			in_game = true;
			gamesystem_start_game();
		},
		leave: function() {
			in_game = false;
			
			time_source_destroy_safe(ts_ping);
		},
		
		
	},
});
fsm.get_step_paused = function() {
	return PAUSED;
};
fsm.change("game_ended");

#endregion



var lay = layer_get_id("Background");
if layer_exists(lay) layer_set_visible(lay,false);







