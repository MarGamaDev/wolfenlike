extends Node3D

var nodes : Array[Node]
var grid_spaces : Array[GridSpace] = []
var grid_locations : Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nodes = get_children()
	for current_space : Node in nodes:
		##replace this with something in level generator that gets their position as part of it
		##this is getting the space of the grid and createing a new gridspace
		var node_name = current_space.get_name().split(", ", false)
		var x = node_name[0].to_int()
		var y = node_name[1].to_int()
		var new_space = Vector2(x, y)
		var new_grid_space = GridSpace.new()
		new_grid_space.create_grid_space(new_space,[])
		
		##this will be replaced when the generator creates wall data when level is made
		##currently looks at rotation of walls around the space. it can't really see half walls.
		##that should be fixed when change is made to generator
		##it is just finding where it's walls are, but the way this *should* be done is more like,
		##when neighbours are being checked, each neighbouring space should look at it's walls, then
		##figure out if movement should be able to get there
		for i in current_space.get_children():
			if i is RigidBody3D:
				match i.rotation_degrees:
					Vector3(0.0, 0.0, 0.0):
						new_grid_space.wall_directions.append(Vector2(0,-1))
					Vector3(0.0, -90.0, 0.0):
						new_grid_space.wall_directions.append(Vector2(1,0))
					Vector3(0.0, -180.0, 0.0):
						new_grid_space.wall_directions.append(Vector2(0,1))
					Vector3(0.0, 90.0, 0.0):
						new_grid_space.wall_directions.append(Vector2(-1,0))
		
		grid_spaces.append(new_grid_space)
		grid_locations.append(new_space)
	
	for space in grid_spaces:
		set_neighbours(space)
	
	#for space in grid_spaces:
		#print(space.grid_position)
		#print(space.wall_directions)
		#var test = []
		#for i in space.neighbours:
			#test.append(i.grid_location)
		#print(test)
		#test = []
		#for i in space.neighbours:
			#test.append(i.cost_to_move_here)
		#print(test)
		#print("")

func get_space_in_grid(location : Vector2) -> GridSpace:
	for space in grid_spaces:
		if space.grid_position == location:
			return space
	return null

func set_neighbours(grid_space : GridSpace) -> void:
	var neighbours : Array[GridNeighbour] = []
	var location : Vector2 = grid_space.grid_position
	
	##gets the surrounding spaces (including itself)
	for x_check : int in range(-1, 2):
		for y_check : int in range(-1, 2):
			var direction_to_check : Vector2 = Vector2(location.x + x_check, location.y + y_check)
			#creates a new neighbour in that direction
			var new_neighbour : GridNeighbour = GridNeighbour.new()
			new_neighbour.grid_location = direction_to_check
			#this will be null if there isn't a space there
			new_neighbour.grid_space = get_space_in_grid(direction_to_check)
			if grid_locations.has(direction_to_check):
				#right now i'm just checking if there's a wall in this direction. it should probably
				#be a characteristic of the gridnode of 'which directions am i blocked from' that
				#is assigned based off of the half wall-type
				var direction : Vector2 = direction_to_check - location
				if grid_space.wall_directions.has(direction):
					new_neighbour.cost_to_move_here = 2000
				else:
					#means there is a space that exists here, and there is nothing blocking it
					new_neighbour.cost_to_move_here = 0
			else:
				#if there isn't a space with a floor there
				new_neighbour.cost_to_move_here = 1000
			neighbours.append(new_neighbour)
	
	grid_space.neighbours = neighbours
