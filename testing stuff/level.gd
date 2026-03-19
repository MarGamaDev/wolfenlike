class_name Level extends Node3D

var grid_nodes : Array[GridNode] = []
var grid_locations : Array[Vector2] = []

func _ready() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func setup_level() -> void:
	##make a list of the locations that are in-bounds
	for grid_node in grid_nodes:
		if grid_node.has_floor:
			grid_locations.append(grid_node.grid_position)
	
	##sets up neighbours
	for space in grid_nodes:
		set_neighbours(space)
	
	#set up cardinally blocked directions
	for space in grid_nodes:
		space.setup_blocked_diagonal_directions()
	
	##once neighbours are set, setups up costs
	for space in grid_nodes:
		set_costs(space)
	
	##debug printout
	#for space in grid_nodes:
		#print("grid position: ", space.grid_position)
		#print("blocked off from ", space.blocked_directions)
		#var test = []
		#for i in space.neighbours:
			#test.append([i.grid_location, i.cost_to_move_here])
		#print("neighbours and their costs: ", test)
		#print("")

func get_space_in_grid(location : Vector2) -> GridNode:
	for space in grid_nodes:
		if space.grid_position == location:
			return space
	return null

func set_neighbours(grid_node : GridNode) -> void:
	var neighbours : Array[GridNeighbour] = []
	var location : Vector2 = grid_node.grid_position
	
	#gets the surrounding spaces (including itself)
	for x_check : int in range(-1, 2):
		for y_check : int in range(-1, 2):
			var direction_to_check : Vector2 = Vector2(location.x + x_check, location.y + y_check)
			#creates a new neighbour in that direction
			var new_neighbour : GridNeighbour = GridNeighbour.new()
			new_neighbour.grid_location = direction_to_check
			#if this neighbouring location holds a gridnode (meaning is in bounds)
			if grid_locations.has(direction_to_check):
				new_neighbour.is_there_a_node_here = true
				new_neighbour.grid_node = get_space_in_grid(direction_to_check)
				new_neighbour.direction_from_current_node = new_neighbour.grid_location - location
			else:
				new_neighbour.is_there_a_node_here = false
			neighbours.append(new_neighbour)
	grid_node.neighbours = neighbours

func set_costs(grid_node : GridNode) -> void:
	for neighbour : GridNeighbour in grid_node.neighbours:
		#if there is no floor there/oob
		if neighbour.is_there_a_node_here == false:
			neighbour.cost_to_move_here = 1000
		#if the neighbour is in a direction that the current node can't go
		elif grid_node.blocked_directions.has(neighbour.direction_from_current_node):
			neighbour.cost_to_move_here = 2000
		else:
			var direction_from_neighbour : Vector2 = grid_node.grid_position - neighbour.grid_location
			#if the neighbour can't reach the current node
			if neighbour.grid_node.blocked_directions.has(direction_from_neighbour):
				neighbour.cost_to_move_here = 3000
			else:
				#there is nothing in the way
				neighbour.cost_to_move_here = 0

			##if this neighbouring location holds a gridnode (meaning is in bounds)
			#if grid_locations.has(direction_to_check):
				#new_neighbour.is_there_a_node_here = true
				#new_neighbour.grid_node = get_space_in_grid(direction_to_check)
				##var direction_from_neighbour : Vector2 = location - direction_to_check
				##from the neighbour's perspective, is this move valid?
				#if new_neighbour.grid_node.blocked_directions.has(direction_from_neighbour):
					##if it's blocked off, set cost to high 
					#new_neighbour.cost_to_move_here = 2000
				#else:
					##means there is a space that exists here, and there is nothing blocking it
					#new_neighbour.cost_to_move_here = 0
			#else:
				##if there isn't a space with a floor there
#
				#new_neighbour.cost_to_move_here = 1000


##OLD STUFF THAT I WANNA KEEP FOR A MOMENT
## FROM SETUP:
	#nodes = get_children()
	#for current_space : Node in nodes:
		###replace this with something in level generator that gets their position as part of it
		###this is getting the space of the grid and createing a new GridNode
		#var node_name = current_space.get_name().split(", ", false)
		#var x = node_name[0].to_int()
		#var y = node_name[1].to_int()
		#var new_space = Vector2(x, y)
		#var new_grid_space = GridNode.new()
		#new_grid_space.create_grid_space(new_space,[])
		#
		###this will be replaced when the generator creates wall data when level is made
		###currently looks at rotation of walls around the space. it can't really see half walls.
		###that should be fixed when change is made to generator
		###it is just finding where it's walls are, but the way this *should* be done is more like,
		###when neighbours are being checked, each neighbouring space should look at it's walls, then
		###figure out if movement should be able to get there
		#for i in current_space.get_children():
			#if i is RigidBody3D:
				#match i.rotation_degrees:
					#Vector3(0.0, 0.0, 0.0):
						#new_grid_space.wall_directions.append(Vector2(0,-1))
					#Vector3(0.0, -90.0, 0.0):
						#new_grid_space.wall_directions.append(Vector2(1,0))
					#Vector3(0.0, -180.0, 0.0):
						#new_grid_space.wall_directions.append(Vector2(0,1))
					#Vector3(0.0, 90.0, 0.0):
						#new_grid_space.wall_directions.append(Vector2(-1,0))
