class_name QueenShotgun extends PlayerWeapon

@onready var raycasts : Array[RayCast3D] = []
@onready var shot_point : Node3D = $ShotPoint

##keep these odd numbers unless we update so it doesn't shoot right ahead as well
@export var shot_num_x : float = 5 
@export var shot_num_y : float  = 3
var number_of_shots : int

@export var x_seperation : float = 5
@export var y_seperation : float = 5
@export var randomness_spread : float = 1.5

var center_bullet_x : float 
var center_bullet_y : float 
var start_pos_x : float
var start_pos_y : float 


func _ready() -> void:
	##will need to update this to work with even grid stuff
	center_bullet_x = ceil(shot_num_x / 2)
	center_bullet_y = ceil(shot_num_y / 2)
	start_pos_x = (center_bullet_x - 1) * x_seperation * -1
	start_pos_y = (center_bullet_y - 1) * y_seperation * -1

func shoot():
	raycasts = []
	number_of_shots = shot_num_x * shot_num_y
	
	for i in range(0, number_of_shots):
		var new_cast : RayCast3D = RayCast3D.new()
		raycasts.append(new_cast)
		shot_point.add_child(new_cast)
		new_cast.set_collision_mask_value(1, false)
		new_cast.set_collision_mask_value(2, true)
	
	var x_pos : float = start_pos_x
	var y_pos : float =  start_pos_y
	var ray_count : int = 0
	for row in range(0, shot_num_y):
		for column in range(0, shot_num_x):
			var new_target : Vector3 = Vector3(x_pos + randf_range(-randomness_spread, randomness_spread), y_pos + randf_range(-randomness_spread, randomness_spread), -20.0)
			var ray : RayCast3D = raycasts[ray_count]
			ray.target_position = new_target
			ray.force_raycast_update()
			ray_count += 1
			x_pos += x_seperation
		x_pos = start_pos_x
		y_pos += y_seperation
		
	
	for ray in raycasts:
		if ray.is_colliding():
			print("hit")
			if ray.get_collider().is_in_group("enemy"):
				ray.get_collider().on_hit()
	
	##replace later with visuals
	await get_tree().create_timer(0.5).timeout
	for ray in raycasts:
		ray.queue_free()
