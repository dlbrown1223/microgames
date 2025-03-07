
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_worldpos;

uniform vec3 col_bright;
uniform vec3 col_dark;
uniform sampler2D backtex;
uniform sampler2D dithertex;
uniform float itime;
uniform float size;

void main()
{
	
	float t = itime/50.0;
	float scale = 1.0;
	vec2 coords_a = v_worldpos * (1.0/725.0)*scale + vec2(1.1252,0.964)*t*1.154 + vec2(234.65363,75.245);
	vec4 perlin_a = texture2D( gm_BaseTexture, coords_a );
	vec2 coords_b = v_worldpos * (1.0/335.0)*scale; + vec2(0.73545,-0.435424)*t*0.136;
	coords_b += perlin_a.rg*0.07;
	vec4 perlin_b = texture2D( gm_BaseTexture, coords_b );
		
	float value = perlin_b.r;
	float dither = texture2D( dithertex, gl_FragCoord.xy/16.0).r; //dither size is 16
	value += (dither-1.0)*0.5;
	value = clamp(value,0.0,1.0);
	
	vec3 outrgb = col_bright;
	if (value > 0.33){
		outrgb = col_dark;
	}
	
	//vec4 gradcolor = texture2D( backtex, vec2( 0.0, value ) ); //sample gradient
	//vec3 outrgb = gradcolor.rgb;
	
    gl_FragColor = v_vColour * vec4(outrgb,1.0);
}
