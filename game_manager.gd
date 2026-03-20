class_name GameManager extends Node3D

@export var TEST_game_muted : bool

@onready var player : Player = $Player
@onready var level : Level = $new_level
@onready var enemy_manager : EnemyManager = $EnemyManager
@onready var pause_screen : PauseScreen = $PauseMenu
@onready var music_player : AudioStreamPlayer = $MusicPlayer
@onready var rhythm_manager : RhythmManager = $RhythmSyncManager

var grid_nodes : Array[GridNode]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_manager.setup_enemy_manager(level, player)
	grid_nodes = level.grid_nodes
	print(grid_nodes.size())
	
	if TEST_game_muted:
		music_player.volume_db = -80
	
	rhythm_manager.player = music_player
	rhythm_manager.start_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pause_pressed() -> void:
	pause_screen.on_game_paused()
	pass # Replace with function body.


func _on_beat() -> void:
	enemy_manager.on_enemy_turn()
	pass # Replace with function body.
