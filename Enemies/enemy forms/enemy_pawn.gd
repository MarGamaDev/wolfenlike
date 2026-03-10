class_name EnemyPawn extends Enemy

func decide_next_move(player_position : Vector2, spaces_taken : Array[Vector2]) -> Vector2:
	var next_move_target : Vector2
	var possible_moves : Array[Vector2] = []
	for i in range(0,4):
		possible_moves.append(grid_position)
	possible_moves[0].x += 1
	possible_moves[1].x -= 1
	possible_moves[2].y += 1
	possible_moves[3].y -= 1
	var closest_distance : float = 10000
	var current_distance : float = find_distance_to_player(grid_position, player_position)
	var flag_to_move : bool = false
	var closest_move : Vector2
	var count : int = 0
	for possible_move in possible_moves:
		var possible_distance : float = find_distance_to_player(possible_move, player_position) 
		if possible_distance <= current_distance && possible_distance <= closest_distance:
			if spaces_taken.find(possible_move) == -1:
				closest_distance = possible_distance
				flag_to_move = true
				closest_move = possible_moves[count]
		count += 1
	if flag_to_move:
		print("moving into: ", closest_move, " from ", grid_position)
	else:
		print("no move available")
	return next_move_target

func find_distance_to_player(test_position : Vector2, player_position : Vector2) -> float:
	var path_vector : Vector2 = player_position - test_position
	var distance_possible : float = sqrt((path_vector.x * path_vector.x) + (path_vector.y * path_vector.y)) / grid_size
	return distance_possible
