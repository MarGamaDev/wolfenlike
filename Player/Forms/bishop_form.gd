class_name BishopForm extends PlayerForm

@export var diagonal_move_boost : float = 2.0
@export var cardinal_move_penalty : float = 0.5

func initialize(set_player : Player) -> void:
	super(set_player)
	weapon = load("res://Player/weapons/bishop_sniper.tscn").instantiate()
	player.get_weapon_holder().add_child(weapon)


func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	super(input_vector, delta)
	
	if direction:
		if (input_vector.x + input_vector.y == 1) || (input_vector.x + input_vector.y == -1):
			player.velocity.x = direction.x * player.SPEED * cardinal_move_penalty
			player.velocity.z = direction.z * player.SPEED  * cardinal_move_penalty
		else:
			player.velocity.x = direction.x * player.SPEED * diagonal_move_boost
			player.velocity.z = direction.z * player.SPEED * diagonal_move_boost
	else:
		on_directional_input_stopping()

	player.move_and_slide()
