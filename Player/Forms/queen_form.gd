class_name QueenForm extends PlayerForm

@export var queen_movement_boost : float = 2.0

func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	var direction := (head.transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	
	if direction:
		player.velocity.x = direction.x * player.SPEED 
		player.velocity.z = direction.z * player.SPEED
		player.velocity = player.velocity * queen_movement_boost
	
	##TODO:get a grip on how momentum should feel and figure out how to implement that
	else:
		##what should happen when the player stops inputting?
		player.velocity.x = 0.0
		player.velocity.z = 0.0

	player.move_and_slide()
