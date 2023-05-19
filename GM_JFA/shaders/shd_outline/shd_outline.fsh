varying vec2 v_coord;
varying vec4 v_color;

uniform float u_radius;

//Center RG value
#define CENTER 127.0/255.0
//RG value range
#define RANGE  255.0

void main()
{
	vec4 tex = texture2D(gm_BaseTexture, v_coord);
	float dist = tex.a<1.0? length(tex.rg-CENTER)*RANGE : 0.0;
	//(1.0-tex.a) * RANGE/2.0;
	
    gl_FragColor = (dist<0.5)? tex : vec4(0.8, 0.8, 0.9, u_radius-dist);
	//Glow example: vec4(1.5,1.3,.2,1)/sqrt(sqrt(dist))
}