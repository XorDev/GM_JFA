///@desc Update outline radius

//Mouse wheel delta
var _delta = mouse_wheel_up() - mouse_wheel_down();
//Scroll up and down
radius = radius*(1+0.1*_delta) + _delta;
radius = clamp(radius, 1, 80);
//Smoothly interpolate to target radius
radius_smooth = lerp(radius_smooth, radius, 0.05);