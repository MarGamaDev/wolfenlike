class_name KingPistol extends PlayerWeapon

@onready var aim_ray : RayCast3D = $RayCast3D

func shoot() -> void:
	if aim_ray.is_colliding():
		if aim_ray.get_collider().is_in_group("enemy"):
			print("enemy shot")
