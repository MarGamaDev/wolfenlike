class_name PlayerForm extends Node

var player : Player
var head : Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initialize(set_player : Player) -> void:
	player = set_player
	head = player.head
	pass

func handle_directional_input(input_vector : Vector2, delta : float) -> void:
	pass
