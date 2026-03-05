class_name BasicPlayerForm extends PlayerForm

func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	super(input_vector, delta)
	
	if direction:
		player.velocity.x = direction.x * player.SPEED
		player.velocity.z = direction.z * player.SPEED
	else:
		on_directional_input_stopping()
	player.move_and_slide()
