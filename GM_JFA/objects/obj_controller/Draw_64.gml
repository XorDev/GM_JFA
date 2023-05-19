///@desc Draw JFA and outline

//Make sure surfaces exist
if !surface_exists(surf_ping) surf_ping = surface_create(width, height);
if !surface_exists(surf_pong) surf_pong = surface_create(width, height);

//Get texel size
var _tex,_texel_w,_texel_h;
_tex	 = surface_get_texture(surf_ping);
_texel_w = texture_get_texel_width(_tex);
_texel_h = texture_get_texel_height(_tex);

//Temporary variables for ping-ponging
//See: https://mini.gmshaders.com/p/gm-shaders-mini-recursive-shaders-1308459
var _surf1, _surf2, _surf3;
_surf1 = surf_ping;
_surf2 = surf_pong;

//Disable blending
gpu_set_blendenable(false);
//Clear surfacne and draw example sprite
surface_set_target(_surf1);
draw_clear_alpha(0,0);
draw_sprite(spr_example, 0, 0, 0);
surface_reset_target();

//Sample jump distance and first pass bool
var _jump,_first;
_jump = 64;
_first = true;

//Repeat pass until jump is one
while(_jump>=1)
{
	//Swap surfaces
	_surf3 = _surf1;
	_surf1 = _surf2;
	_surf2 = _surf3;
	
	//Apply JFA pass
	surface_set_target(_surf1);
	shader_set(shd_jfa);
	shader_set_uniform_f(u_texel, _texel_w, _texel_h);
	shader_set_uniform_f(u_first, _first);
	shader_set_uniform_f(u_jump, _jump);
	draw_surface(_surf2, 0, 0);
	shader_reset();
	surface_reset_target();
	
	//All other passes are false
	_first = false;
	//Half jump size with each pass
	_jump /= 2;
}

//Draw outline for example
if !mouse_check_button(mb_left)
{
	shader_set(shd_outline);
	gpu_set_blendenable(true);
	shader_set_uniform_f(u_radius, radius_smooth);
}
gpu_set_blendenable(true);
//Draw final surface
draw_surface_ext(_surf1,0,0,1,1,0,-1,1);
shader_reset();
gpu_set_blendenable(true);
