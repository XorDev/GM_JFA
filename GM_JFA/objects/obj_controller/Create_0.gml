///@desc Initialize variables

//Outline radius for example
radius = 32;
radius_smooth = radius;

//JFA uniforms
u_texel = shader_get_uniform(shd_jfa, "u_texel");
u_first = shader_get_uniform(shd_jfa, "u_first");
u_jump  = shader_get_uniform(shd_jfa, "u_jump");

//Outline uniform for example
u_radius = shader_get_uniform(shd_outline, "u_radius");

//Resolution variables for surfaces
width = room_width;
height = room_height;

//Variables for surfaces
surf_ping = -1;
surf_pong = -1;