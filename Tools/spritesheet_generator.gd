@tool
class_name SpritesheetGenerator
extends SubViewport

@export_tool_button("Generate Spritesheet", "Callable") var capture_action = capture_sprites
@export var model_holder: Node3D
@export var filename: String = "model_sheet"

var angles: Array[float] = [0, 315, 270, 225, 180, 45, 90, 135]

func capture_sprites() -> void:
	var index: int = 0
	var format = get_texture().get_image().get_format();
	var result = Image.create_empty(size.x * 8, size.y, false, format);
	
	for angle in angles:
		model_holder.rotation.y = deg_to_rad(angle)
		await RenderingServer.frame_post_draw
		var img = get_texture().get_image()
		result.blit_rect(img, Rect2i(0,0, size.x, size.y), Vector2i(size.x * index, 1))
		index += 1
	
	model_holder.rotation.y = 0.0
	result.save_png("res://Spritesheets/%s.png" % filename) 
