class_name TestEnemy extends Enemy



func initialize(set_player : Player) -> void:
	super(set_player)

func decide_next_move(player_position : Vector2, spaces_taken : Array[Vector2]):
	nav_agent.set_target_position(player.global_position)
	var next_nav_point : Vector3 = nav_agent.get_next_path_position()
	var path = nav_agent.get_current_navigation_path()
	print(path)
	print("distance ", nav_agent.get_next_path_position())
	var direction : Vector3 = (next_nav_point - global_transform.origin) * grid_size
	print("direction ", direction)
