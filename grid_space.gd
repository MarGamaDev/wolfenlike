class_name GridSpace extends Node3D

var grid_size : int = 5

var grid_position : Vector2
var neighbours : Array[GridNeighbour] = []
##this should be replaced with which directions am I able to go in
var wall_directions : Array[Vector2] = []

func create_grid_space(new_position : Vector2, new_neighours : Array[GridSpace]) -> void:
	grid_position = new_position
	for neighbour : GridSpace in new_neighours:
		var new_neighbour : GridNeighbour = GridNeighbour.new()
		new_neighbour.grid_space = neighbour
		neighbours.append(neighbour)
