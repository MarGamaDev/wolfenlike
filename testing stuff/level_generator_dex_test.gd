@tool
class_name LevelGeneratorTest
extends Node

@export_tool_button("Generate Level", "Callable") var generate_action = generate_level;
@export var level_name: String = "new_level";

var level_path: String = "res://Levels/";

func generate_level() -> void:
	print("reading data")
	var walls: TileMapLayer = $Walls;
	var floors: TileMapLayer = $Floors;
	var half_walls: TileMapLayer = $"Half_Walls";
	var entities: TileMapLayer = $Entities;
	var level_tiles: Array[Node];
	
	## Create a new level object
	print("creating level named: " + level_name)
	##CHANGED this to create a level typed object
	var level: Level;
	level = find_child(level_name);
	if level == null:
		level = Level.new()
		get_tree().edited_scene_root.add_child(level)
		level.owner = self;
		level.name = level_name;
	else:
		for child in level.get_children():
			child.queue_free();
	
	##Added an array of the gridnodes for the level
	var grid_nodes : Array[GridNode] = []
	
	for cell_position in walls.get_used_cells():
		#print("creating cell: ", cell_position)
		##CHANGED to be a GridNode
		var cell = GridNode.new();
		level.add_child(cell)
		cell.owner = self
		cell.name = "%s, %s" % [cell_position.x, cell_position.y]
		
		##ADDED setting up some GridNode attributes
		cell.grid_position = Vector2(cell_position.x, cell_position.y)
		
		
		# configuring cell
		if floors.get_cell_tile_data(cell_position):
			var floor_data: int = floors.get_cell_tile_data(cell_position).get_custom_data("floor_id");
			add_floors(cell, floor_data);
			##setting gridnode variable
			cell.has_floor = true
		else:
			cell.has_floor = false
		
		if walls.get_cell_tile_data(cell_position):
			var wall_data: String = walls.get_cell_tile_data(cell_position).get_custom_data("wall_id");
			add_walls(cell, wall_data);
		
		if half_walls.get_cell_tile_data(cell_position):
			var halfwall_data: String = half_walls.get_cell_tile_data(cell_position).get_custom_data("halfwall_id");
			add_halfwalls(cell, halfwall_data);
		
		cell.position = Vector3(cell_position.x, 0, cell_position.y);
		
		##adds cell to gridnode array
		cell.setup_blocked_cardinal_directions()
		grid_nodes.append(cell)
	
	level.grid_nodes = grid_nodes
	level.setup_level()

##CHANGED cell type to gridnode
func add_floors(cell: GridNode, customdata: int) -> void:
	var floor: Node3D;
	match customdata:
		0:
			floor = load("res://Tools/Levelgen Data/Tile Parts/Floor.tscn").instantiate();
		1:
			floor = load("res://Tools/Levelgen Data/Tile Parts/damaging_floor.tscn").instantiate();
		_:
			pass
	cell.add_child(floor);
	floor.owner = self

##added part to tell which directions walls are
func add_walls(cell: GridNode, customdata: String) -> void:
	if customdata.contains("n"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/wall.tscn").instantiate();
		cell.add_child(wall);
		wall.owner = self;
		cell.wall_directions.append(Vector2.UP)
	if customdata.contains("e"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(-90))
		cell.add_child(wall);
		wall.owner = self;
		cell.wall_directions.append(Vector2.RIGHT)
	if customdata.contains("s"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(180))
		cell.add_child(wall);
		wall.owner = self;
		cell.wall_directions.append(Vector2.DOWN)
	if customdata.contains("w"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(90))
		cell.add_child(wall);
		wall.owner = self;
		cell.wall_directions.append(Vector2.LEFT)

##added same for this
func add_halfwalls(cell: GridNode, customdata: String) -> void:
	if customdata.contains("n"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/half_wall.tscn").instantiate();
		cell.add_child(wall);
		wall.owner = self;
		cell.half_wall_directions.append(Vector2.UP)
	if customdata.contains("e"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/half_wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(-90))
		cell.add_child(wall);
		wall.owner = self;
		cell.half_wall_directions.append(Vector2.RIGHT)
	if customdata.contains("s"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/half_wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(180))
		cell.add_child(wall);
		wall.owner = self;
		cell.half_wall_directions.append(Vector2.DOWN)
	if customdata.contains("w"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/half_wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(90))
		cell.add_child(wall);
		wall.owner = self;
		cell.half_wall_directions.append(Vector2.LEFT)
