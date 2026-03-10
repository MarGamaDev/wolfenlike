class_name EnemyManager extends Node3D

@export var grid_size : int = 7
@export var enemy_y_level : float = 1.8

##currently an export just for testing
var enemies : Array[Enemy] = []

func _ready() -> void:
	for i in get_children():
		enemies.append(i)
	print(enemies.size())
	align_enemies()


func align_enemies() -> void:
	var spaces_taken : Array[Vector2] = []
	for enemy : Enemy in enemies:
		enemy.position.y = enemy_y_level
		print(enemy.position)
		var z_factor : float = floor(enemy.global_position.z / grid_size)
		var x_factor : float = floor(enemy.global_position.x / grid_size)
		enemy.grid_position = Vector2(x_factor,z_factor)
		var space_taken_flag : bool = false
		for coords in spaces_taken:
			if enemy.grid_position == coords:
				space_taken_flag = true
		if space_taken_flag == false:
			spaces_taken.append(enemy.grid_position)
			enemy.global_position.z = (z_factor * grid_size) + (grid_size / 2)
			enemy.global_position.x = (x_factor * grid_size) + (grid_size / 2)
		else:
			print("space taken!")
		print(enemy.global_position)
	pass
