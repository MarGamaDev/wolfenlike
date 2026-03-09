class_name PlayerForm extends Node3D

var player : Player
var head : Node3D
var weapon : PlayerWeapon
var direction : Vector3 = Vector3.ZERO
var stop_delta : float
var stop_time : float = 0.1
var attack_soul_consumption : int = 1

enum PLAYER_FORM {KING, PAWN, ROOK, KNIGHT, BISHOP, QUEEN}
var player_form : PLAYER_FORM

func initialize(set_player : Player) -> void:
	player = set_player
	head = player.head
	attack_soul_consumption = 1
	pass

func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	direction = (head.transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()

func handle_movement_ability() -> void:
	direction = (head.transform.basis * Vector3(0, 0, -1)).normalized()
	pass

func end_move_ability() -> void:
	pass

func on_directional_input_stopping() -> void:
	player.velocity -= player.velocity * min(stop_delta/stop_time, 1.0)
	#player.velocity.x = 0.0
	#player.velocity.z = 0.0 

func handle_attack_input() -> void:
	player.consume_soul(attack_soul_consumption)
	weapon.shoot()

func on_process_update(delta : float) -> void:
	stop_delta = delta
