class_name PlayerForm extends Node3D

var player : Player
var head : Node3D
var weapon : PlayerWeapon
var direction : Vector3 = Vector3.ZERO
var stop_delta : float
var stop_time : float = 0.1
@export var attack_soul_consumption : float = 1
@export var movement_boost_consumption : float = 0.001

@export var attack_speed : float = 1 ## how many seconds between attacks
var attack_timer : Timer

enum PLAYER_FORM {KING, PAWN, ROOK, KNIGHT, BISHOP, QUEEN}
var player_form : PLAYER_FORM

var is_active : bool = false

func initialize(set_player : Player) -> void:
	player = set_player
	head = player.head
	attack_timer = player.attack_timer
	attack_timer.wait_time = attack_speed
	is_active = true
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
	if attack_timer.is_stopped():
		weapon.shoot()
		attack_timer.start()
		player.consume_soul(attack_soul_consumption)

func on_process_update(delta : float) -> void:
	stop_delta = delta

func set_inactive() -> void:
	if is_active:
		is_active = false
		weapon.queue_free()
