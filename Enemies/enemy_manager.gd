class_name EnemyManager extends Node3D

@export var grid_size : int = 7
@export var enemy_y_level : float = 1.8

@export var player : Player

##currently an export just for testing
var enemies : Array[Enemy] = []

func _ready() -> void:
	for i in get_children():
		enemies.append(i)
	##THIS RE-ORDERING OF ENEMIES WILL LATER BE MOVED TO DECISION MAKING AND NOT ALIGNING
	enemies.sort_custom(sort_by_enemy_type)
	align_enemies()


func align_enemies() -> void:
	var spaces_taken : Array[Vector2] = []
	for enemy : Enemy in enemies:
		enemy.position.y = enemy_y_level
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
			## TESTING, WILL BE MOVED TO DECISION MAKING LATER
			print("space taken!")
			var new_position : Vector2 = find_closest_space_to_player(enemy.grid_position, spaces_taken)
			print("go to ", str(new_position))

func find_player_grid_position() -> Vector2:
	print(player.global_position)
	var z_factor : float = floor(player.global_position.z / grid_size)
	var x_factor : float = floor(player.global_position.x / grid_size)
	var grid_position : Vector2 = Vector2(x_factor, z_factor)
	return grid_position

func sort_by_enemy_type(a : Enemy, b : Enemy) -> bool:
	##return true if a should go before b
	if a.enemy_type < b.enemy_type:
		return true
	else:
		return false

func find_closest_space_to_player(enemy_position : Vector2, unavailable_positions : Array[Vector2]) -> Vector2:
	var grid_position : Vector2
	grid_position = find_player_grid_position()
	return grid_position 
