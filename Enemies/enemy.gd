class_name Enemy extends CharacterBody3D

enum ENEMY_TYPE {KING, QUEEN, BISHOP, KNIGHT, ROOK, PAWN}

var grid_position : Vector2
@export var enemy_type : ENEMY_TYPE


func on_hit(damage : float): 
	pass
