varying vec2 v_coord;
varying vec4 v_color;

uniform float u_radius;

#define RANGE 255.0

void main()
{
	vec4 tex = texture2D(gm_BaseTexture, v_coord);
	float dist = (1.0-tex.a) * RANGE/2.0;
	
    gl_FragColor = (dist<0.5)? tex : vec4(0.8, 0.8, 0.9, u_radius-dist);
}