class_name QueenShotgun extends PlayerWeapon

@onready var raycasts : Array[RayCast3D] = []
@onready var shot_point : Node3D = $ShotPoint

@export var number_of_shots : int = 3
@export var x_spread : float = 5
@export var y_spread : float = 5

func shoot():
	raycasts = []
	for i in range(0, 3):
		var new_cast : RayCast3D = RayCast3D.new()
		raycasts.append(new_cast)
		shot_point.add_child(new_cast)
		new_cast.set_collision_mask_value(2, true)
		new_cast.target_position = Vector3(randf_range(-x_spread,x_spread),randf_range(-y_spread,y_spread),-20.0)
	
	for ray in raycasts:
		if ray.is_colliding():
			if ray.get_collider().is_in_group("enemy"):
				ray.get_collider().on_hit()
	
	raycasts[2].queue_free()
	raycasts[1].queue_free()
	raycasts[0].queue_free()
