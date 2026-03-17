class_name EnemyManager extends Node3D

@export var grid_size : int = 3
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
	update_enemy_array()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		print("player grid position: ", find_player_grid_position())
		on_enemy_turn()

func update_enemy_array():
	enemies = []
	for enemy : Enemy in get_children():
		enemies.append(enemy)
	enemies.sort_custom(sort_by_enemy_type)
	align_enemies()

func on_enemy_turn() -> void:
	var player_position : Vector2 = find_player_grid_position()
	for enemy : Enemy in enemies:
		occupied_spaces = enemy.decide_next_move(player_position, occupied_spaces)
	for enemy : Enemy in enemies:
		enemy.move_enemy()
	resfresh_spaces_taken()
	print("occupied spaces: ", occupied_spaces)
	pass

func resfresh_spaces_taken():
	occupied_spaces = []
	for enemy :Enemy in enemies:
		occupied_spaces.append(enemy.grid_position)

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
			enemy.global_position.z = (z_factor * grid_size) + (grid_size / 2.0)
			enemy.global_position.x = (x_factor * grid_size) + (grid_size / 2.0)
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
