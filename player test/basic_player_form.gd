class_name BasicPlayerForm extends PlayerForm

func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	var direction := (head.transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	if direction:
		player.velocity.x = direction.x * player.SPEED
		player.velocity.z = direction.z * player.SPEED
	
	##TODO:get a grip on how momentum should feel and figure out how to implement that
	else:
		##what should happen when the player stops inputting?
		player.velocity.x = 0.0
		player.velocity.z = 0.0

	player.move_and_slide()
