class_name GameManager extends Node3D

@onready var player : Player = $Player
@onready var level : Level = $new_level
@onready var enemy_manager : EnemyManager = $EnemyManager
@onready var pause_screen : PauseScreen = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pause_pressed() -> void:
	pause_screen.on_game_paused()
	pass # Replace with function body.
