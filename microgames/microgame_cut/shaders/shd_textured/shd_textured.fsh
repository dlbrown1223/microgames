//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D texture;

void main()
{
	
	vec4 surfcol = texture2D( gm_BaseTexture, v_vTexcoord );
	
	vec2 texpos = v_vTexcoord*8.0;
	vec4 texcol = texture2D( texture, texpos );
	
	vec4 outcol = vec4(texcol.rgb,surfcol.a);
	
	
	
    gl_FragColor = v_vColour * outcol;
}
