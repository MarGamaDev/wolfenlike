class_name EnemyRook extends Enemy

@export var move_range : int = 4
@export var dash_range : int = 3
@export var dash_damage : float = 2
@export var rooket_damage : float = 2

var charge_attack_flag : bool = false

func initialize(set_player : Player):
	super(set_player)
	nav_agent = $NavigationAgent3D

func decide_next_move(player_position : Vector2, spaces_taken : Array[Vector2]) -> Array[Vector2]:
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
	#check to see if player is in line for charge attack
	occupied_spaces = do_charge_check(player_position, occupied_spaces, path)
	if charge_attack_flag:
		post_move_action_flag = true
		return occupied_spaces
	#get direction towards player from nav and normalize
	var path_direction : Vector2 = get_nav_path_direction_to_player(path).normalized()
	#it will want to move in this direction, and rather than the pawn that will always try and move
	#if it can, the rook will opt to only move in this direction, and fire an attack from where it is
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
	#print("initial direction: ", initial_direction)
	#now we'll start moving it forward and checking until it reaches a space it cannot go to
	var next_space_index : int = 1
	var stop_flag : bool = false
	var next_space : Vector2 = grid_position
	#store distance from player
	var initial_distance : float = find_distance_to_player(grid_position, player_position)
	var last_distance : float  = initial_distance
	#print("initial distance: ", initial_distance)
	while next_space_index <= move_range && stop_flag == false:
		var next_space_check = (next_space_index * initial_direction) + grid_position
		#if we hit an occupied space, stop moving
		if occupied_spaces.find(next_space_check) != -1:
			stop_flag = true
		#check to see if pathing from current position is straight.
		var straight_path_flag : bool = straight_path_check(next_space)
		#check to see distance the next move will put us in
		var potential_distance_to_player : float = find_distance_to_player(next_space_check, player_position)
		#print(potential_distance_to_player)
		#if path is straight, therefore the rook is not trying to navigate around somehting:
		if straight_path_flag:
			#if we would move farther away from the player
			if potential_distance_to_player > last_distance:
				print("stop test")
				stop_flag = true
		#and once it gets close enough to player
		if next_space_check == player_position or potential_distance_to_player < 0.15:
			stop_flag = true
			#print("stopping next to player")
		#if it doesn't trigger any of these things, we can move to the next space
		if stop_flag == false:
			next_space = next_space_check
			last_distance = potential_distance_to_player
		next_space_index += 1
	grid_position = next_space
	#print(grid_position)
	return occupied_spaces

func straight_path_check(space_to_check : Vector2) -> bool:
	var result : bool = false
	var current_position : Vector3 = global_position
	var test_global_position : Vector3 =convert_grid_to_global_position(space_to_check)
	global_position.x = test_global_position.x
	global_position.z = test_global_position.z
	nav_agent.set_target_position(player.global_position)
	var next_nav_point : Vector3 = nav_agent.get_next_path_position()
	var check_path = nav_agent.get_current_navigation_path()
	if check_path.size() >= 2:
		var straightness : float = (check_path[0] - check_path[1]).normalized().dot((check_path[check_path.size()-2]-check_path[check_path.size()-1]).normalized())
		if straightness ==  1:
			print("strtness when checked: ", straightness)
			result = true
	global_position = current_position
	nav_agent.set_target_position(player.global_position)
	next_nav_point = nav_agent.get_next_path_position()
	var path = nav_agent.get_current_navigation_path()
	nav_agent.debug_enabled = true
	return result
	
func on_finishing_movement() -> void:
	if charge_attack_flag:
		charge_attack_flag = false

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
	
