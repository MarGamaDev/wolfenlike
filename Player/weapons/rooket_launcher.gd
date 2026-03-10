class_name RooketLauncher extends PlayerWeapon

@onready var launch_point : Node3D = $LaunchPoint

var rooket_scene : PackedScene

func _ready() -> void:
	rooket_scene = preload("res://Player/weapons/rooket.tscn")
	pass

func shoot():
	var new_rooket : Rooket = rooket_scene.instantiate()
	new_rooket.rocket_damage = damage
	add_child(new_rooket)
	new_rooket.global_position = launch_point.global_position
	new_rooket.rotation = launch_point.global_rotation
