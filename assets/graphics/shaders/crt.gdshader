shader_type canvas_item;

uniform bool show_deform = true;
uniform float deform_amount_x : hint_range(3.0, 15.0) = 5.0;
uniform float deform_amount_y : hint_range(3.0, 15.0) = 5.0;

uniform float aberration : hint_range(0, 1) = 0.01;

uniform bool show_scanlines = true;

uniform bool show_vignette = true;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

vec2 deform_uv(vec2 uv, vec2 deform) {
	if (show_deform) {
		uv = uv * 2.0 - 1.0;
		vec2 offset = abs(uv.yx) / deform;
		uv = uv + uv * offset * offset;
		return uv * 0.5 + 0.5;
	}
	return uv;
}

void fragment() {
	vec3 color = vec3(0.0);
	vec2 uv = deform_uv(SCREEN_UV, vec2(deform_amount_x, deform_amount_y));
	vec2 uv_center = uv - vec2(0.5);
	vec2 uv2 = uv_center * uv_center;
	
	color.r = textureLod(SCREEN_TEXTURE, uv, 0.0).r;
	color.g = textureLod(SCREEN_TEXTURE, uv + vec2(aberration * uv2.x, 0.0), 0.0).g;
	color.b = textureLod(SCREEN_TEXTURE, uv - vec2(aberration * uv2.x, 0.0), 0.0).b;
	
	if (show_scanlines) {
		color.rg = color.rg * (0.99 + 0.01 * sin(SCREEN_UV * PI * 720.0));
	}
	
	if (show_vignette) {
		color = color * (1.0 - length(uv2));		
	}
	
	if ( uv.x < 0.0 || uv.y < 0.0 ) {
		color = color * max(0.0, 1.0 + 500.0 * min(uv.x, uv.y));
	} 
	if ( uv.x > 1.0 || uv.y > 1.0 ) {
		color = color * max(0.0, 1.0 + 500.0 * (1.0 - max(uv.x, uv.y)));
	}
	
	COLOR.rgb = color;
}
