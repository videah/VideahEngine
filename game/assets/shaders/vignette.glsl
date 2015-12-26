vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec2  center = vec2(love_ScreenSize.x / 2, love_ScreenSize.y / 2);
	float aspect = love_ScreenSize.x / love_ScreenSize.y;
	float distance_from_center = distance(screen_coords, center);
	float power = 2.25;
	float offset = 2.0;
	float noise_strength = 0.125;
	vec4 tex = texture2D(texture, screen_coords / 128.0) * noise_strength;
	return (color + tex) * vec4(vec3(1.0 - pow(distance_from_center / (center.x * offset), power) + (1.0 - color.a)), 1.0);
}
