shader_type canvas_item;

uniform vec4 color_tint: hint_color;
uniform float glare_power = 0.0;
uniform int glare_steps = 24;
uniform float glare_blur = 0.0;
uniform float glare_offset = 0.001;
uniform int video_degr_steps = 2;
uniform float video_degr_time_scale = 3.0;
uniform float video_degr_scale = 2.0;
uniform float video_degr_step_offset = 0.0;
uniform float video_degr_darken = 0.3;
uniform float video_degr_brighten = 3.0;
uniform sampler2D video_degr_tex;
uniform float rgb_offset_uv_power = 0.01;
uniform int rgb_offset_steps = 10;
uniform float rgb_offset_power = 0.3;
uniform float broken_glass_move_progress = 0.0;
uniform sampler2D broken_glass_tex;
uniform sampler2D broken_glass_gray_tex;
uniform sampler2D broken_glass_move_tex;
uniform float glitch_uv_scale = 1.0;
uniform float glitch_power = 0.01;
uniform sampler2D glitch_tex;

vec4 overlay(vec4 base, vec4 blend) {
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

vec2 overlay_vec2(vec2 base, vec2 blend) {
	vec2 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

vec4 adjust_color(vec4 color, float bright, float contrast, float saturation) {
	color.rgb = mix(vec3(0.0), color.rgb, bright);
    color.rgb = mix(vec3(0.5), color.rgb, contrast);
    color.rgb = mix(
		vec3(dot(vec3(1.0), color.rgb) * 0.33333), 
		color.rgb, 
		saturation
	);
	return color;
}

vec4 apply_rgb_offset(sampler2D tex, vec2 tex_uv, vec4 screen) {
	vec4 og_screen = screen;
	vec2 uv_offset0 = vec2(rgb_offset_uv_power, 0.0);
	vec2 uv_offset1 = vec2(0.0, rgb_offset_uv_power);
	vec2 uv_offset2 = vec2(-rgb_offset_uv_power, 0.0);
	vec2 uv_offset3 = vec2(0.0, rgb_offset_uv_power);
	for(int count = 0; count < rgb_offset_steps; count++) {
		vec4 screen_offset0 = texture(tex, tex_uv + uv_offset0);
		vec4 screen_offset1 = texture(tex, tex_uv + uv_offset1);
		vec4 screen_offset2 = texture(tex, tex_uv + uv_offset2);
		vec4 screen_offset3 = texture(tex, tex_uv + uv_offset3);
		screen_offset0 = adjust_color(screen_offset0, 1.0, 1.0, 0.0);
		screen_offset1 = adjust_color(screen_offset1, 1.0, 1.0, 0.0);
		screen_offset2 = adjust_color(screen_offset2, 1.0, 1.0, 0.0);
		screen_offset3 = adjust_color(screen_offset3, 1.0, 1.0, 0.0);
		screen.r += screen_offset0.r;
		screen.r += screen_offset1.r;
		screen.b += screen_offset2.b;
		screen.gb += screen_offset3.gb;
		uv_offset0.x += rgb_offset_uv_power;
		uv_offset1.y += rgb_offset_uv_power;
		uv_offset2.x -= rgb_offset_uv_power;
		uv_offset3.y -= rgb_offset_uv_power;
	}
	screen = clamp(screen, vec4(0.0), vec4(1.0));
	screen = mix(og_screen, screen, rgb_offset_power);
	return screen;
}

vec4 apply_glare(sampler2D tex, vec2 tex_uv, vec4 screen) {
	float power = glare_power;
	float offset = 0.0;
	float offset_add = glare_offset;
	int steps = glare_steps;
	for(int iter = 0; iter < steps; iter++) {
		offset += offset_add;
		vec2 tex_uv_offset0 = tex_uv - vec2(offset, 0.0);
		vec2 tex_uv_offset1 = tex_uv + vec2(offset, 0.0);
		tex_uv_offset0.x = clamp(tex_uv_offset0.x, 0.0, 1.0);
		tex_uv_offset1.x = clamp(tex_uv_offset1.x, 0.0, 1.0);
		vec4 screen0 = textureLod(tex, tex_uv_offset0, glare_blur);
		vec4 screen1 = textureLod(tex, tex_uv_offset1, glare_blur);
		screen += screen0 * power;
		screen += screen1 * power;
	}
	screen = clamp(screen, vec4(0.0), vec4(1.0));
	return screen;
}

void fragment() {
	vec2 screen_uv = SCREEN_UV;
	vec4 screen = texture(SCREEN_TEXTURE, screen_uv);
	screen = apply_glare(SCREEN_TEXTURE, screen_uv, screen);
	screen = apply_rgb_offset(SCREEN_TEXTURE, screen_uv, screen);
	screen *= color_tint;
	screen.a = 1.0;
	
	screen.rgb = vec3(1.0) - screen.rgb;
	screen = adjust_color(screen, 0.8, 2.0, 0.0);
	
	COLOR = screen;
}
