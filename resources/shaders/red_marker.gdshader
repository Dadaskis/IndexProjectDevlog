shader_type canvas_item;

void fragment() {
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	screen.rgb = vec3(1.0) - screen.rgb;
	screen.rgb *= vec3(1.0, 0.0, 0.0);
	
	COLOR = screen;
}