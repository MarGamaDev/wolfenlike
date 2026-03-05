class_name PlayerForm extends Node

var player : Player
var head : Node3D

func initialize(set_player : Player) -> void:
	player = set_player
	head = player.head
	pass

func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	pass
