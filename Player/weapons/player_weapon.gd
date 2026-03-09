class_name PlayerWeapon extends Node3D

var player : Player
var damage : float
var is_active : bool = false

func initialize(set_player : Player) -> void:
	player = set_player

func shoot():
	pass
