class_name RookForm extends PlayerForm

@export var cardinal_move_boost : float = 2.0
@export var diagonal_move_penalty : float = 0.5


func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	var direction := (head.transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	
	if direction:
		if (input_vector.x + input_vector.y == 1) || (input_vector.x + input_vector.y == -1):
			player.velocity.x = direction.x * player.SPEED * cardinal_move_boost
			player.velocity.z = direction.z * player.SPEED * cardinal_move_boost
		else:
			player.velocity.x = direction.x * player.SPEED * diagonal_move_penalty
			player.velocity.z = direction.z * player.SPEED  * diagonal_move_penalty
	
	##TODO:get a grip on how momentum should feel and figure out how to implement that
	else:
		##what should happen when the player stops inputting?
		player.velocity.x = 0.0
		player.velocity.z = 0.0

	player.move_and_slide()
