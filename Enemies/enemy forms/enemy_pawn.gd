class_name EnemyPawn extends Enemy

@onready var swipe_collider : Area3D = $SwipeAttackBox

func _ready() -> void:
	#super()
	swipe_collider.process_mode = Node.PROCESS_MODE_DISABLED

#returns the now occupied spaces
func decide_next_move(player_position : Vector2, spaces_taken : Array[Vector2]) -> Array[Vector2]:
	print("pawn turn")
	#print("current pawn position: ", grid_position)
	last_position = grid_position
	var occupied_spaces : Array[Vector2] = spaces_taken
	#if player is in the same space as enemy they just do their attack but don't move
	if player_position == grid_position:
		post_move_action_flag = true
		return occupied_spaces
	#update nav agent with player's position and setup path
	#nav_agent.set_target_position(player.global_position)
	#var next_nav_point : Vector3 = nav_agent.get_next_path_position()
	#var path = nav_agent.get_current_navigation_path()
	#get direction towards player from nav and normalize
	#var path_direction : Vector2 = get_nav_path_direction_to_player(path)
	#find current distance to player and a distance checker
	#var current_distance : float = find_distance_to_player(grid_position, player_position)
	#find adjecent spaces without other enemies
	var possible_moves : Array[Vector2] = find_possible_moves(occupied_spaces)
	#compare all possible moves (that aren't occupied) to this direction
	if possible_moves.size() > 0:
		#set variables to find closest possible move to path
		#var next_move = compare_to_nav_direction(possible_moves, path_direction)
		#print("moving into: ", next_move, " from ", grid_position)
		#occupied_spaces = update_occupied_spaces(occupied_spaces, grid_position, next_move)
		#grid_position = next_move
		##we only want the pawn to attack once it moves
		post_move_action_flag = true
	else:
		print("no possible moves")
	#print("move decided.")
	return occupied_spaces

func find_possible_moves(spaces_taken : Array[Vector2]) -> Array[Vector2]:
	var possible_moves : Array[Vector2] = []
	var potential_moves : Array[Vector2] = []
	for i in range(0,4):
		potential_moves.append(grid_position)
	potential_moves[0].x += 1
	potential_moves[1].x -= 1
	potential_moves[2].y += 1
	potential_moves[3].y -= 1
	
	for i in range(0,4):
		if spaces_taken.find(potential_moves[i]) == -1:
			possible_moves.append(potential_moves[i])
	return possible_moves

func on_finishing_movement() -> void:
	swipe_collider.process_mode = Node.PROCESS_MODE_ALWAYS
	await get_tree().create_timer(0.1).timeout
	swipe_collider.process_mode = Node.PROCESS_MODE_DISABLED
	pass

func _on_swipe_attack_box_body_entered(body: Node3D) -> void:
	if body == player:
		player.take_damage(damage)
		print("player hit")
