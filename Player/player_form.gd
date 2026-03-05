class_name PlayerForm extends Node

var player : Player
var head : Node3D
var weapon : PlayerWeapon
var direction : Vector3 = Vector3.ZERO

func initialize(set_player : Player) -> void:
	player = set_player
	head = player.head
	pass

func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	direction = (head.transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()

func on_directional_input_stopping() -> void:
	player.velocity.x = 0.0
	player.velocity.z = 0.0

func handle_attack_input() -> void:
	weapon.shoot()
