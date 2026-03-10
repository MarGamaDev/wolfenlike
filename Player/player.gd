class_name Player extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const CAMERA_SENSITIVITY : float = 0.001
const CAMERA_ROTATION_MAX : float = 60.0
const CAMERA_ROTATION_MIN : float = -40.0

@onready var head : Node3D = $Head
@onready var camera : Camera3D = $Head/Camera3D

@onready var current_form : PlayerForm 
var current_player_form_type : PlayerForm.PLAYER_FORM = PlayerForm.PLAYER_FORM.KING
@export var ammo_from_pawns : int = 5

@export var test_form : PlayerForm.PLAYER_FORM
@export var test_form_list : Array[PlayerForm]
@export var test_soul_label : Label
@export var test_stack_label : Label

var remaining_soul : float  = 0
@onready var attack_timer : Timer = $PlayerForms/Timer

var soul_stack : Array[PlayerForm.PLAYER_FORM] = []

func _ready():
	##TODO create a basic loading system? currently just have the different forms as child of player since there will be limited amounts
	switch_form(test_form)
	#soul_stack.append(PlayerForm.PLAYER_FORM.KING)
	#soul_stack.append(PlayerForm.PLAYER_FORM.BISHOP)
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
		#print(global_position)
		consume_soul(11)

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("player_left","player_right","player_forward","player_backward")
	current_form.handle_directional_input(input_dir, delta)
	current_form.on_process_update(delta)

func get_weapon_holder() -> Node3D:
	return $Head/Camera3D/WeaponHolder

func consume_soul(amount_used : float) -> void:
	remaining_soul -= amount_used
	test_soul_label.text = "remaining soul charge: " + str("%.2f" % remaining_soul)
	if remaining_soul <= 0:
		##this is where going down would go
		if soul_stack.is_empty():
			print("lose game")
		else:
			var new_form : PlayerForm.PLAYER_FORM = soul_stack.pop_back()
			switch_form(new_form)
		pass
	pass

func set_soul(new_value : int) -> void:
	remaining_soul = new_value
	test_soul_label.text = "remaining soul charge: " + str(remaining_soul)

##testing stuff
@export var name_label_test : Label

func switch_form(new_form : PlayerForm.PLAYER_FORM) -> void:
	##MAKE THIS ACTUALLY LOAD THEM AND NOT JUST BE CHILDREN OF PLAYERFORMS
	if current_form:
		current_form.set_inactive()
	current_form = test_form_list[new_form]
	current_form.initialize(self)
	current_player_form_type = current_form.player_form
	##testing stuff
	name_label_test.text = "current form: " + str(PlayerForm.PLAYER_FORM.find_key(new_form))
	var new_stack = ""
	for i in range(0, soul_stack.size()):
		new_stack = new_stack + str(PlayerForm.PLAYER_FORM.find_key(soul_stack[i])) + " "
	test_stack_label.text = "current stack: " + new_stack

func pick_up_form(new_form : PlayerForm.PLAYER_FORM) -> void:
	if new_form == PlayerForm.PLAYER_FORM.PAWN:
		set_soul(ammo_from_pawns + remaining_soul)
	else:
		soul_stack.append(current_player_form_type)
		switch_form(new_form)

func take_damage(damage_amount : float) -> void:
	consume_soul(damage_amount)

##TESTING STUFF
#signal update_soul_text(text : String)
#func update_soul_label(text : String):
