class_name GridNode extends Node3D

var grid_size : int = 5

var grid_position : Vector2 = Vector2.ZERO
var neighbours : Array[GridNeighbour] = []
var wall_directions : Array[Vector2] = []
var half_wall_directions : Array[Vector2] = []
#this will contain a list of directions in the form of (1/0/-1, 1/0/-1) showing the places
#that you are blocked from while in this space based on the walls that this space has
var blocked_directions : Array[Vector2] = []
var has_floor : bool

func _ready() -> void:
	if has_node("Floor"):
		has_floor = true
	
	var node_position : PackedStringArray = name .split(", ")
	grid_position = Vector2(node_position[0].to_float(), node_position[1].to_float())
	
	#grabbing wall data
	var nodes : Array[Node] = get_children()
	var walls : Array[RigidBody3D] = []
	for node in nodes:
		##NEED TO MAKE THIS SOMEHOW TELL BETWEEN WALLS AND HALF WALLS
		if node is RigidBody3D:
			walls.append(node)
	for wall : RigidBody3D in walls:
		var wall_rotation : float  = wall.rotation.y
		match wall_rotation:
			deg_to_rad(0.0):
				wall_directions.append(Vector2.UP)
			deg_to_rad(-90.0):
				wall_directions.append(Vector2.RIGHT)
			deg_to_rad(180.0):
				wall_directions.append(Vector2.DOWN)
			deg_to_rad(90.0):
				wall_directions.append(Vector2.LEFT)
	
	setup_blocked_cardinal_directions()

func setup_blocked_cardinal_directions() -> void:
	#setting cardinal blocked passages ONLY LOOKING AT THE WALLS CURRENTLY, UPDATED LATER
	if wall_directions.has(Vector2.UP) || half_wall_directions.has(Vector2.UP):
		blocked_directions.append(Vector2.UP)
	if wall_directions.has(Vector2.RIGHT) || half_wall_directions.has(Vector2.RIGHT):
		blocked_directions.append(Vector2.RIGHT)
	if wall_directions.has(Vector2.DOWN) || half_wall_directions.has(Vector2.DOWN):
		blocked_directions.append(Vector2.DOWN)
	if wall_directions.has(Vector2.LEFT) || half_wall_directions.has(Vector2.LEFT):
		blocked_directions.append(Vector2.LEFT)
	
	if blocked_directions.has(Vector2.UP) && blocked_directions.has(Vector2.RIGHT):
		blocked_directions.append(Vector2(1.0, -1.0))
	if blocked_directions.has(Vector2.RIGHT) && blocked_directions.has(Vector2.DOWN):
		blocked_directions.append(Vector2(1.0, 1.0))
	if blocked_directions.has(Vector2.DOWN) && blocked_directions.has(Vector2.LEFT):
		blocked_directions.append(Vector2(-1.0, 1.0))
	if blocked_directions.has(Vector2.LEFT) && blocked_directions.has(Vector2.UP):
		blocked_directions.append(Vector2(-1.0, -1.0))

func setup_blocked_diagonal_directions() -> void:
	var potential_diagonals : Array[Vector2] = [Vector2(1.0,-1.0),Vector2(1.0,1.0),Vector2(-1.0,0.0),Vector2(-1.0,-1.0)]
	for direction : Vector2 in potential_diagonals:
		var block_flag : bool = false
		#if the walls in this direction are not perfectly clear
		if blocked_directions.has(Vector2(direction.x, 0.0)) || blocked_directions.has(Vector2(0.0, direction.y)):
			block_flag = true
			var neighbour_to_check : GridNeighbour
			var neighbour_node : GridNode
			#if it's able to take one of the two paths around the corner, make it so it's not blocked
			for neighbour in neighbours:
				if neighbour.direction_from_current_node == Vector2(0.0, direction.y):
					neighbour_to_check = neighbour
			if neighbour_to_check != null:
				if neighbour_to_check.is_there_a_node_here:
					neighbour_node = neighbour_to_check.grid_node
					if blocked_directions.has(Vector2(0.0,direction.y)) == false && neighbour_node.blocked_directions.has(Vector2(direction.x,0.0)) == false:
						block_flag = false
				
			for neighbour in neighbours:
				if neighbour.direction_from_current_node == Vector2(direction.x, 0.0):
					neighbour_to_check = neighbour
			if neighbour_to_check != null:
				if neighbour_to_check.is_there_a_node_here:
					neighbour_node = neighbour_to_check.grid_node
					if blocked_directions.has(Vector2(direction.x, 0.0)) == false && neighbour_node.blocked_directions.has(Vector2(0.0, direction.y)) == false:
						block_flag = false
		
		if block_flag && blocked_directions.has(direction) == false:
			blocked_directions.append(direction)

	
	
