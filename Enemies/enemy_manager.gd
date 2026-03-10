class_name EnemyManager extends Node3D

@export var grid_size : int = 7
@export var enemy_y_level : float = 1.8

@export var player : Player

##currently an export just for testing
var enemies : Array[Enemy] = []
var occupied_spaces : Array[Vector2] = []

func _ready() -> void:
	for i : Enemy in get_children():
		enemies.append(i)
		i.initialize(player)
		i.grid_size = grid_size
	##THIS RE-ORDERING OF ENEMIES WILL LATER BE MOVED TO DECISION MAKING AND NOT ALIGNING
	enemies.sort_custom(sort_by_enemy_type)
	align_enemies()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		on_enemy_turn()
		print(occupied_spaces)

func on_enemy_turn() -> void:
	enemies.sort_custom(sort_by_enemy_type)
	var player_position : Vector2 = find_player_grid_position()
	for enemy in enemies:
		var new_grid_position : Vector2 = enemy.decide_next_move(player_position, occupied_spaces)
		enemy.global_position.x = (new_grid_position.x * grid_size) +  (grid_size / 2)
		enemy.global_position.z = (new_grid_position.y * grid_size) +  (grid_size / 2)
		align_enemies()
	for enemy in enemies:
		enemy.on_finishing_movement()
	pass

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
			print("space taken!")
	occupied_spaces = spaces_taken

func find_player_grid_position() -> Vector2:
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
