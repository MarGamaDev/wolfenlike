class_name RookForm extends PlayerForm

@export var cardinal_move_boost : float = 2.0
@export var diagonal_move_penalty : float = 0.5
@export var charge_speed : float = 4

var dash_active : bool = false
var dash_direction : Vector3

func initialize(set_player : Player) -> void:
	super(set_player)
	weapon = load("res://Player/weapons/rooket_launcher.tscn").instantiate()
	player.get_weapon_holder().add_child(weapon)

func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	super(input_vector, delta)
	if dash_active == false:
		if direction:
			if (input_vector.x + input_vector.y == 1) || (input_vector.x + input_vector.y == -1):
				player.velocity.x = direction.x * player.SPEED * cardinal_move_boost
				player.velocity.z = direction.z * player.SPEED * cardinal_move_boost
			else:
				player.velocity.x = direction.x * player.SPEED * diagonal_move_penalty
				player.velocity.z = direction.z * player.SPEED  * diagonal_move_penalty
		else:
			on_directional_input_stopping()
		player.move_and_slide()

func handle_movement_ability() -> void:
	super()
	dash_direction = direction
	dash_active = true

func end_move_ability() -> void:
	dash_active = false

func _physics_process(delta: float) -> void:
	if dash_active:
		player.velocity.x = dash_direction.x * player.SPEED * charge_speed
		player.velocity.z = dash_direction.z * player.SPEED * charge_speed
		player.move_and_slide()
	pass
