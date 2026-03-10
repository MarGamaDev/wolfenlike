class_name Enemy extends CharacterBody3D

enum ENEMY_TYPE {KING, QUEEN, BISHOP, KNIGHT, ROOK, PAWN}

var grid_position : Vector2
var grid_size : float
@export var enemy_type : ENEMY_TYPE
@export var damage : float
var player : Player

func initialize(set_player : Player):
	player = set_player

func on_hit(damage : float): 
	pass

func decide_next_move(player_position : Vector2, spaces_taken : Array[Vector2]) -> Vector2:
	var next_move_target : Vector2
	return next_move_target

func on_finishing_movement() -> void:
	pass
