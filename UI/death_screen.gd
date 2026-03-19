extends Control

func _on_player_death() -> void:
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

func _on_return_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	pass # Replace with function body.
