class_name BishopSniper extends PlayerWeapon

@onready var aim_ray : RayCast3D = $RayCast3D

func shoot() -> void:
	var objects_collided : Array[Object] = []
	while aim_ray.is_colliding():
		var next_object = aim_ray.get_collider()
		objects_collided.append(next_object)
		aim_ray.add_exception(next_object)
		aim_ray.force_raycast_update()

	for object in objects_collided:
		aim_ray.remove_exception(object)
		if object.is_in_group("enemy"):
			object.on_hit()
	
