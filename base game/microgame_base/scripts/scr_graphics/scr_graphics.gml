
#macro BACKGROUND global._background


function background_init() {
	
	BACKGROUND = {
		color_bright: #300E39,
		color_dark: #4D1446,
	};
}

function draw_background() {
	//var t = current_time/50;
	//draw_sprite_tiled(sp_title_background,0,t,t);
	
	
	var itime = current_time/1000;
	
	var filter = gpu_get_tex_filter();
	gpu_set_tex_filter(true);
	shader_set(shd_background);
	
	static u_itime = shader_get_uniform(shd_background,"itime");
	shader_set_uniform_f(u_itime,itime);
	
	static u_size = shader_get_uniform(shd_background,"size");
	shader_set_uniform_f(u_size,VWID,VHEI);
	
	static u_col_bright = shader_get_uniform(shd_background,"col_bright");
	static u_col_dark = shader_get_uniform(shd_background,"col_dark");
	shader_set_uniform_color(u_col_bright,BACKGROUND.color_bright);
	shader_set_uniform_color(u_col_dark,BACKGROUND.color_dark);
	
	static u_backtex = shader_get_sampler_index(shd_background,"backtex");
	static backtex = sprite_get_texture(sp_tex_background,0);
	texture_set_stage(u_backtex,backtex);
	gpu_set_tex_filter_ext(u_backtex,false);
	
	static u_dithertex = shader_get_sampler_index(shd_background,"dithertex");
	static dithertex = sprite_get_texture(sp_tex_dither,0);
	texture_set_stage(u_dithertex,dithertex);
	gpu_set_tex_filter_ext(u_dithertex,false);
	
		draw_sprite_stretched(sp_tex_perlin,0, 0,0, VWID,VHEI);
	shader_reset();
	gpu_set_tex_filter(filter);
	
}

