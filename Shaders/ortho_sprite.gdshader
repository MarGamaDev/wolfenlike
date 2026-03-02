shader_type spatial;
render_mode unshaded, depth_prepass_alpha, depth_draw_opaque;

uniform sampler2D default_sprite_sheet: filter_nearest_mipmap;
uniform int columns = 8;

varying vec3 look_dir;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
	look_dir = normalize(MODELVIEW_NORMAL_MATRIX * NORMAL);
}

void fragment() {
	float f_ncolumns = float(columns);
	
	// cam_dir = CAMERA_DIRECTION_WORLD; is sufficient for orthogonal camera
	vec3 ray_origin = CAMERA_POSITION_WORLD;
	// Instead of calculating object origin, uniform for mesh.global_position wold work better for x/y impostor billboard
	vec3 object_origin = (MODEL_MATRIX * vec4(0.0,0.0,0.0,1.0)).xyz;
	vec3 cam_dir = object_origin - ray_origin;
	cam_dir = normalize((VIEW_MATRIX * vec4(cam_dir, 0.0)).xyz);
	
	// Getting direction through dot product
	// Assumin that NPC looking at it's positive Z direction
	float angle = 3.0 - acos(dot(normalize(cam_dir.xz), normalize(look_dir.xz)));
	float _direction = round(angle/6.0 * f_ncolumns);
	
	// Flipping left/right animations based on cross product
	vec3 right_cross = normalize(cross(normalize(look_dir), vec3(0.0, 1.0, 0.0)));
	float right = sign(dot(right_cross.xz, cam_dir.xz));
	
	// Getting correct frame
	vec2 frame = vec2(_direction, 1.0);
	bool is_perpendicular = float(int(_direction) % 4) == 0.0;
	if(right < 0.0 && !is_perpendicular) {
		frame += vec2(4.0, 0.0);
	}
	vec2 frame_size = vec2(f_ncolumns, 1.0);
	vec4 tex = texture(default_sprite_sheet, (UV + frame) / frame_size);
	
	ALBEDO = tex.rgb;
	ALPHA =  tex.a;
}
