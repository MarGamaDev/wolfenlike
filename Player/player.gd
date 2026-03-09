class_name Player extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_SENSITIVITY : float = 0.001
const CAMERA_ROTATION_MAX : float = 60.0
const CAMERA_ROTATION_MIN : float = -40.0

@onready var head : Node3D = $Head
@onready var camera : Camera3D = $Head/Camera3D

var current_form : PlayerForm
var player_form_type : PlayerForm.PLAYER_FORM = PlayerForm.PLAYER_FORM.KING

@export var test_form : PlayerForm.PLAYER_FORM
@export var test_form_list : Array[PlayerForm]
@export var test_soul_label : Label

var remaining_soul : int = 0

func _ready():
	##TODO create a basic loading system? currently just have the different forms as child of player since there will be limited amounts
	switch_form(test_form)
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
	
	if Input.is_action_just_pressed("player_move_ability"):
		current_form.handle_movement_ability()
	
	##testing tools
	if Input.is_action_just_pressed("test_stop_dash"):
		current_form.end_move_ability()
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
	return $Head/Camera3D/WeaponHolder

func consume_soul(amount_used : int) -> void:
	remaining_soul -= amount_used
	test_soul_label.text = "remaining soul charge: " + str(remaining_soul)
	if remaining_soul <= 0:
		##this is where going down would go
		switch_form(PlayerForm.PLAYER_FORM.KING)
		pass
	pass

func set_soul(new_value : int) -> void:
	remaining_soul = new_value
	test_soul_label.text = "remaining soul charge: " + str(remaining_soul)

func switch_form(new_form : PlayerForm.PLAYER_FORM) -> void:
	##MAKE THIS ACTUALLY LOAD THEM AND NOT JUST BE CHILDREN OF PLAYERFORMS
	current_form = test_form_list[new_form]
	current_form.initialize(self)
	player_form_type = current_form.player_form
	print("switched form to: ", new_form)

##TESTING STUFF
#signal update_soul_text(text : String)
#func update_soul_label(text : String):
