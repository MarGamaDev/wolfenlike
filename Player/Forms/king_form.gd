class_name KingForm extends PlayerForm

func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	var direction := (head.transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	
	if direction:
		player.velocity.x = direction.x * player.SPEED
		player.velocity.z = direction.z * player.SPEED
	
	##TODO:get a grip on how momentum should feel and figure out how to implement that
	else:
		##what should happen when the player stops inputting?
		player.velocity.x = 0.0
		player.velocity.z = 0.0

	player.move_and_slide()
