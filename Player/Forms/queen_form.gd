class_name QueenForm extends PlayerForm

@export var queen_movement_boost : float = 2.0

@export var starting_soul : int = 10
@export var queen_passive_soul_drain_rate : float = 0.01

func initialize(set_player : Player) -> void:
	super(set_player)
	weapon = load("res://Player/weapons/queen_shotgun.tscn").instantiate()
	player.get_weapon_holder().add_child(weapon)
	player_form = PLAYER_FORM.QUEEN
	player.set_soul(starting_soul)

func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	super(input_vector, delta)
	
	if direction:
		player.velocity.x = direction.x * player.SPEED 
		player.velocity.z = direction.z * player.SPEED
		player.velocity = player.velocity * queen_movement_boost
	
	##TODO:make this more slidey
	else:
		on_directional_input_stopping()

	player.move_and_slide()

func on_process_update(delta : float) -> void:
	super(delta)
	player.consume_soul(queen_passive_soul_drain_rate)
