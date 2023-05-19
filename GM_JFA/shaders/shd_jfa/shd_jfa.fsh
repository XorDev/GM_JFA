varying vec2 v_coord;
varying vec4 v_color;

//The size of a texel (1 / texture_resolution)
uniform vec2 u_texel;
//Jump distance in pixels
uniform float u_jump;
//Starting pass (1.0 if first, 0.0 after)
uniform float u_first;

//Center RG value
#define CENTER 127.0/255.0
//RG value range
#define RANGE  255.0

//Jump Flooding Algorithm
//RG encodes XY offset
//Alpha encodes inverted distance
vec4 JFA(sampler2D t, vec2 uv)
{
	//True if this is the first pass
	bool first = u_first>0.5;
	//Initialize output
    vec4 encode = vec4(0.0);
    
    //Loop through neighbor cells
    for(int x = -1; x <= 1; x++)
    for(int y = -1; y <= 1; y++)
    {
    	//Pixel offset with jump distance
    	vec2 off = vec2(x,y) * u_jump;
    	//Compute new texture coordinates
    	vec2 coord = uv + off * u_texel;
		//Skip texels outside of the texture
		if (coord != clamp(coord, 0.0, 1.0)) continue;
		
    	//Sample the texture at the coordinates
        vec4 samp = texture2D(t, coord);
        
        //If we're over the surface, preserves the color
        if (x==0 && y==0 && samp.a>=1.0)
        {
            return samp;
        }
        //Encode the offset (-0.5 to +0.5)
    	vec2 encode_off = (samp.rg - CENTER)*vec2(samp.a<1.0) + off / RANGE;
    	//Compute offset distance (inverted)
    	float dist = 1.0 - length(encode_off)*2.0; 
    	
    	//Check for the closest
    	if (dist > encode.a && (!first || samp.a>=1.0))
    	{
			//Store texel offset
    		encode.rg = encode_off + CENTER;
			//Store the closest distance
    		encode.a = dist;
    	}
    }
    return encode;
}

void main()
{
    gl_FragColor = v_color * JFA(gm_BaseTexture, v_coord);
}
