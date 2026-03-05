class_name KingForm extends PlayerForm

func initialize(set_player : Player) -> void:
	super(set_player)
	weapon = load("res://Player/weapons/king_pistol.tscn").instantiate()
	player.get_weapon_holder().add_child(weapon)


func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	super(input_vector, delta)
	if direction:
		player.velocity.x = direction.x * player.SPEED
		player.velocity.z = direction.z * player.SPEED
	else:
		on_directional_input_stopping()

	player.move_and_slide()
