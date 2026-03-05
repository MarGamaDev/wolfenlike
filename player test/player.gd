extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_SENSITIVITY : float = 0.001
const CAMERA_ROTATION_MAX : float = 60.0
const CAMERA_ROTATION_MIN : float = -40.0

@onready var head : Node3D = $Head
@onready var camera : Camera3D = $Head/Camera3D

func _ready():
	#hiding cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	#when mouse is moved, rotate camera and head seperately
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * CAMERA_SENSITIVITY)
		camera.rotate_x(-event.relative.y * CAMERA_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(CAMERA_ROTATION_MIN), deg_to_rad(CAMERA_ROTATION_MAX))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("player_left","player_right","player_forward","player_backward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	
	##TODO:get a grip on how momentum should feel and figure out how to implement that
	else:
		##what should happen when the player stops inputting?
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()
