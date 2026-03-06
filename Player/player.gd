class_name Player extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_SENSITIVITY : float = 0.001
const CAMERA_ROTATION_MAX : float = 60.0
const CAMERA_ROTATION_MIN : float = -40.0

@onready var head : Node3D = $Head
@onready var camera : Camera3D = $Head/Camera3D

@onready var current_form : PlayerForm

@export var test_form : int
@export var test_form_list : Array[PlayerForm]

func _ready():
	##TODO create a basic loading system? currently just have the different forms as child of player since there will be limited amounts
	current_form = test_form_list[test_form]
	current_form.initialize(self)
	#hiding cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	#when mouse is moved, rotate camera and head seperately
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * CAMERA_SENSITIVITY)
		camera.rotate_x(-event.relative.y * CAMERA_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(CAMERA_ROTATION_MIN), deg_to_rad(CAMERA_ROTATION_MAX))
	
	if Input.is_action_just_pressed("player_attack"):
		current_form.handle_attack_input()
	
	##testing tools
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()
	if Input.is_action_just_pressed("space"):
		#current_form = $PlayerForms/BishopForm
		#current_form.initialize(self)
		print(get_tree_string_pretty())

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("player_left","player_right","player_forward","player_backward")
	current_form.handle_directional_input(input_dir, delta)
	current_form.on_process_update(delta)

func get_weapon_holder() -> Node3D:
	return $Head/WeaponHolder
