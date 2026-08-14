shader_type spatial;
render_mode cull_disabled, diffuse_burley;

uniform vec4 grass_color : source_color = vec4(0.16, 0.48, 0.12, 1.0);
uniform float wind_strength = 0.16;
uniform float wind_speed = 1.6;

void vertex() {
	float wave = sin(TIME * wind_speed + VERTEX.x * 2.4 + INSTANCE_CUSTOM.x * 6.0);
	VERTEX.x += wave * wind_strength * UV.y;
	VERTEX.z += cos(TIME * wind_speed * 0.8 + VERTEX.z * 2.0 + INSTANCE_CUSTOM.x * 4.0) * wind_strength * 0.35 * UV.y;
}

void fragment() {
	ALBEDO = grass_color.rgb;
	ROUGHNESS = 0.92;
}
