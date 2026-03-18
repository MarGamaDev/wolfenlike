shader_type spatial;
render_mode unshaded, depth_prepass_alpha, depth_draw_opaque;

uniform vec4 color1 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color2 : source_color = vec4(0.0, 0.0, 0.0, 0.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 object_origin = (MODEL_MATRIX * vec4(0.0,0.0,0.0,1.0)).xyz;
	int number = int(round(object_origin.x + object_origin.z));
	if (number % 2 == 1) {
		ALBEDO = color1.xyz;
	}
	else {
		ALBEDO = color2.xyz;
	}
}
