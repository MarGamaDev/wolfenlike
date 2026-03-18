class_name Enemy extends CharacterBody3D

signal on_death

enum ENEMY_TYPE {KING, QUEEN, BISHOP, KNIGHT, ROOK, PAWN}

var grid_position : Vector2
var grid_size : float
@export var enemy_type : ENEMY_TYPE
@export var damage : float
var player : Player
var nav_agent : NavigationAgent3D
var last_position : Vector2 = Vector2.ZERO
var post_move_action_flag : bool = false
var health : int

func initialize(set_player : Player):
	player = set_player

func on_hit(damage : float): 
	health -= damage
	if health <= 0 :
		on_death.emit()
	pass

func decide_next_move(player_position : Vector2, spaces_taken : Array[Vector2]) -> Array[Vector2]:
	return []

func get_nav_path_direction_to_player(path : PackedVector3Array) -> Vector2:
	var direction : Vector2 = Vector2.ZERO
	if path.size() > 1:
		var first_point : Vector2 = Vector2(path[0].x, path[0].z)
		var second_point : Vector2 = Vector2(path[1].x, path[1].z)
		direction = second_point - first_point
	#direction = path[0] - path[1]
	return direction.normalized()

func update_occupied_spaces(spaces : Array[Vector2], old_pos : Vector2, new_pos : Vector2) -> Array[Vector2]:
	if spaces.is_empty():
		spaces.append(new_pos)
	else:
		if spaces.has(old_pos):
			spaces.erase(old_pos)
		spaces.append(new_pos)
	return spaces

func move_enemy() -> void:
	global_position.z = (grid_position.y * grid_size) + (grid_size / 2)
	global_position.x = (grid_position.x * grid_size) + (grid_size / 2)
	if post_move_action_flag:
		on_finishing_movement()
		post_move_action_flag = false
	pass

func on_finishing_movement() -> void:
	pass

func find_distance_to_player(grid_position_to_check : Vector2, player_grid_position : Vector2) -> float:
	var path_vector : Vector2 = player_grid_position - grid_position_to_check
	var distance_possible : float = sqrt((path_vector.x * path_vector.x) + (path_vector.y * path_vector.y)) / grid_size
	return distance_possible

func convert_grid_to_global_position(grid_pos : Vector2) -> Vector3:
	var global_pos : Vector3 = Vector3(0,global_position.y, 0)
	global_pos.z = (grid_pos.y * grid_size) + (grid_size / 2)
	global_pos.x = (grid_pos.x * grid_size) + (grid_size / 2)
	return global_pos


#probably don't want this anymore
##this assumes the possible moves are all valid
func compare_to_nav_direction(possible_moves : Array[Vector2], path_direction : Vector2) -> Vector2:
	#print("path direction: ", path_direction)
	var next_move : Vector2 = grid_position
	var closest_direction_to_path : float = -2.0
	for move : Vector2 in possible_moves:	
		var move_direction : Vector2 = move - grid_position
		var direction_angle_difference : float = path_direction.dot(move.normalized())
		if (direction_angle_difference > closest_direction_to_path):
			closest_direction_to_path = direction_angle_difference
			next_move = move
	return next_move
