class_name EnemyRook extends Enemy

@export var move_range : int = 4
@export var dash_range : int = 0
@export var dash_damage : float = 2
@export var rooket_damage : float = 2

var charge_attack_flag : bool = false

func initialize(set_player : Player):
	super(set_player)
	nav_agent = $NavigationAgent3D

func decide_next_move(player_position : Vector2, spaces_taken : Array[Vector2]) -> Array[Vector2]:
	print("starting at: ", grid_position)
	last_position = grid_position
	var occupied_spaces : Array[Vector2] = spaces_taken
	#if player is in the same space as rook, it does a charge
	if player_position == grid_position:
		post_move_action_flag = true
		charge_attack_flag = true
		return occupied_spaces
	#update nav agent with player's position and setup path
	nav_agent.set_target_position(player.global_position)
	var next_nav_point : Vector3 = nav_agent.get_next_path_position()
	var path = nav_agent.get_current_navigation_path()
	#print("path straightness:  ", (path[0] - path[1]).normalized().dot((path[0]-path[path.size()-1]).normalized()))
	#print(path)
	#check to see if player is in line for charge attack
	occupied_spaces = do_charge_check(player_position, occupied_spaces, path)
	if charge_attack_flag:
		post_move_action_flag = true
		return occupied_spaces
	#print("test")
	#get direction towards player from nav and normalize
	var path_direction : Vector2 = get_nav_path_direction_to_player(path).normalized()
	#it will want to move in this direction, and rather than the pawn that will always try and move
	#if it can, the rook will opt to stay nearer teammates if it can't move, and fire an attack from where it is
	var potential_moves : Array[Vector2] = []
	for i in range(0,4):
		potential_moves.append(Vector2.ZERO)
	potential_moves[0].x += 1
	potential_moves[1].x -= 1
	potential_moves[2].y += 1
	potential_moves[3].y -= 1
	for move in potential_moves:
		move.normalized()
	var initial_direction : Vector2 = compare_to_nav_direction(potential_moves, path_direction)
	#now we'll start moving it forward and checking until it reaches a space it cannot go to
	var next_space_index : int = 1
	var stop_flag : bool = false
	var next_space : Vector2
	print(initial_direction)
	while next_space_index <= move_range && stop_flag == false:
		next_space = (next_space_index * initial_direction) + grid_position
		#if we hit an occupied space, stop moving
		if occupied_spaces.find(next_space) != -1:
			stop_flag = true
		#we check the path again now, if it is very different, it means that we are either in front of a wall or just 
		#off course
		##KEEP GOING FROM HERE
		#and once it gets close enough to player
		if next_space == player_position:
			stop_flag = true
			print("stopping next to player")
		next_space_index += 1
	print("stops in : ", next_space)
	grid_position = next_space
	print(grid_position)
	return occupied_spaces

func do_charge_check(player_position : Vector2, spaces_taken : Array[Vector2], path : PackedVector3Array) -> Array[Vector2]:
	var occupied_spaces : Array[Vector2] = spaces_taken
		#if rook is in cardinal direction of player (one of their axis is the same)
	if grid_position.x == player_position.x || grid_position.y == player_position.y && path.size() > 0:
		#checking if path is obstructed by wall based on how straight it is
		if ((path[0] - path[1]).normalized().dot((path[0]-path[path.size()-1]).normalized()) > 0.95) && grid_position.distance_to(player_position) <= dash_range:
			var x_is_same : bool = false
			if grid_position.x == player_position.x:
				x_is_same = true
			#make sure area in between is clear
			var clear_to_charge : bool = true
			var spaces_between : Array[Vector2] = []
			
			if x_is_same: #meaning vertical axis is same
				for y in range(min(grid_position.y, player_position.y) + 1, max(grid_position.y, player_position.y)):
					var space_to_check : Vector2 = Vector2(grid_position.x, y)
					if occupied_spaces.has(space_to_check):
						clear_to_charge = false
					else:
						spaces_between.append(space_to_check)
			else: #meaning y is same
				for x in range(min(grid_position.x, player_position.x) + 1, max(grid_position.x, player_position.x)):
					var space_to_check : Vector2 = Vector2(x, grid_position.y)
					if occupied_spaces.has(space_to_check):
						clear_to_charge = false
					else:
						spaces_between.append(space_to_check)
			
			if clear_to_charge:
				#mark spaces between as occupied so enemies don't move inside
				for space in spaces_between:
					occupied_spaces.append(space)
				#flag to use charge attack
				post_move_action_flag = true
				charge_attack_flag = true
				print("charge!")
	return occupied_spaces
	
