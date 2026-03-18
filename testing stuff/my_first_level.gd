extends Node3D

var nodes : Array[Node]
var grid_spaces : Array[GridSpace] = []
var grid_locations : Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nodes = get_children()
	for current_space : Node in nodes:
		##replace this with something in level generator that gets their position as part of it
		var node_name = current_space.get_name().split(", ", false)
		var x = node_name[0].to_int()
		var y = node_name[1].to_int()
		var new_space = Vector2(x, y)
		var new_grid_space = GridSpace.new()
		new_grid_space.create_grid_space(new_space,[])
		
		##this will be replaced when the generator creates wall data when level is made
		##currently looks at rotation of walls around the space. it can't really see half walls.
		##that should be fixed when change is made to generator
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
			#test.append(i)
		#print(test)
		#print(space.neighbour_costs)
		#print("")


func set_neighbours(grid_space : GridSpace) -> void:
	var neighbours : Array[Vector2] = []
	var grid_location : Vector2 = grid_space.grid_position
	var costs : Array[float] = []
	for x_check : int in range(-1, 2):
		for y_check : int in range(-1, 2):
			var direction_to_check : Vector2 = Vector2(grid_location.x + x_check, grid_location.y + y_check)
			neighbours.append(direction_to_check)
	
	for space : Vector2 in neighbours:
		var direction : Vector2 = space - grid_location
		if grid_space.wall_directions.has(direction):
			costs.append(20000.0)
		if grid_locations.has(space):
			costs.append(0.0)
		else:
			costs.append(10000.0)
	grid_space.update_neighbours(neighbours, costs)
