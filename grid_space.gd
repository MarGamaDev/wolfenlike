class_name GridSpace

var grid_size : int = 5

var grid_position : Vector2
var neighbours : Array[Vector2] = []
var neighbour_costs : Array[float] = []
#if the cell has any walls, which direction they are in
##TODO: currently this just looks at all walls the same, need to change when we change generator
var wall_directions : Array[Vector2] = []

func create_grid_space(new_position : Vector2, new_neighours : Array[Vector2]) -> void:
	grid_position = new_position
	neighbours = new_neighours
	neighbour_costs = []
	for i in neighbours:
		neighbour_costs.append(0.0)

func update_neighbours(new_neighours : Array[Vector2], costs : Array[float]) -> void:
	neighbours = new_neighours
	neighbour_costs = costs
