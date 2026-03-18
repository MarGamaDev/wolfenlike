@tool
class_name LevelGenerator
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
	var level: Node3D;
	level = find_child(level_name);
	if level == null:
		level = Node3D.new();
		get_tree().edited_scene_root.add_child(level)
		level.owner = self;
		level.name = level_name;
	else:
		for child in level.get_children():
			child.queue_free();
	
	for cell_position in walls.get_used_cells():
		print("creating cell: ", cell_position)
		var cell = Node3D.new();
		level.add_child(cell)
		cell.owner = self
		cell.name = "%s, %s" % [cell_position.x, cell_position.y]
		
		# configuring cell
		if floors.get_cell_tile_data(cell_position):
			var floor_data: int = floors.get_cell_tile_data(cell_position).get_custom_data("floor_id");
			add_floors(cell, floor_data);
		
		if walls.get_cell_tile_data(cell_position):
			var wall_data: String = walls.get_cell_tile_data(cell_position).get_custom_data("wall_id");
			add_walls(cell, wall_data);
		
		if half_walls.get_cell_tile_data(cell_position):
			var halfwall_data: String = half_walls.get_cell_tile_data(cell_position).get_custom_data("halfwall_id");
			add_halfwalls(cell, halfwall_data);
		
		cell.position = Vector3(cell_position.x, 0, cell_position.y);

func add_floors(cell: Node3D, customdata: int) -> void:
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

func add_walls(cell: Node3D, customdata: String) -> void:
	if customdata.contains("n"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/wall.tscn").instantiate();
		cell.add_child(wall);
		wall.owner = self;
	if customdata.contains("e"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(-90))
		cell.add_child(wall);
		wall.owner = self;
	if customdata.contains("s"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(180))
		cell.add_child(wall);
		wall.owner = self;
	if customdata.contains("w"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(90))
		cell.add_child(wall);
		wall.owner = self;

func add_halfwalls(cell: Node3D, customdata: String) -> void:
	if customdata.contains("n"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/half_wall.tscn").instantiate();
		cell.add_child(wall);
		wall.owner = self;
	if customdata.contains("e"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/half_wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(-90))
		cell.add_child(wall);
		wall.owner = self;
	if customdata.contains("s"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/half_wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(180))
		cell.add_child(wall);
		wall.owner = self;
	if customdata.contains("w"):
		var wall: Node3D = load("res://Tools/Levelgen Data/Tile Parts/half_wall.tscn").instantiate();
		wall.rotate_y(deg_to_rad(90))
		cell.add_child(wall);
		wall.owner = self;
