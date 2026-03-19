class_name EnemyManager extends Node3D

var grid_size : float
@export var enemy_y_level : float = 1.8

@export var player : Player
@export var level : Level

var enemies : Array[Enemy] = []
var occupied_spaces : Array[Vector2] = []

func _ready() -> void:
	print(level.get_grid_nodes().size())
	#this needs to be replaced ? or may be fine if we just have a manager in each level scene
	for i : Enemy in get_children():
		enemies.append(i)
		i.initialize(player)
		i.grid_size = grid_size
		i.current_node = level.get_space_in_grid(i.grid_position)
		#print("test: ", level.get_space_in_grid(i.grid_position))
		#print(i.current_node)
		#need to connect enemy's signals that are relevant too
	update_enemy_array()

func _process(delta: float) -> void:
	##for testing
	if Input.is_action_just_pressed("space"):
		align_enemies()
		print(find_player_grid_position())

##could be used when enemies are added/removed?
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
	pass

##make sure that occupied spaces is correct
func resfresh_spaces_taken():
	occupied_spaces = []
	for enemy :Enemy in enemies:
		occupied_spaces.append(enemy.grid_position)

##this probably needs to be changed to work with new level system
func align_enemies() -> void:
	#print(level.grid_nodes.size())
	var spaces_taken : Array[Vector2] = []
	for enemy : Enemy in enemies:
		enemy.position.y = enemy_y_level
		enemy.position.x = enemy.current_node.position.x
		enemy.position.z = enemy.current_node.position.z
		spaces_taken.append(enemy.current_node.grid_position)
	occupied_spaces = spaces_taken

func find_player_grid_position() -> Vector2:
	var z_factor : float = floor((player.global_position.z + (grid_size / 2)) / grid_size)
	clamp(z_factor, floor(z_factor), ceil(z_factor))
	var x_factor : float = floor((player.global_position.x + (grid_size / 2)) / grid_size)
	clamp(x_factor, floor(x_factor), ceil(x_factor))
	var grid_position : Vector2 = Vector2(x_factor, z_factor)
	return grid_position

func sort_by_enemy_type(a : Enemy, b : Enemy) -> bool:
	##return true if a should go before b
	if a.enemy_type < b.enemy_type:
		return true
	else:
		return false
