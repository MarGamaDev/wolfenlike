class_name PlayerFormLoader extends Node3D

#enum PLAYER_FORM {KING, PAWN, ROOK, KNIGHT, BISHOP, QUEEN}
var player_form_paths : Array[String] = [
	"res://Player/Forms/king_form.tscn",
	"res://Player/Forms/pawn_form.tscn",
	"res://Player/Forms/rook_form.tscn",
	"res://Player/Forms/knight_form.tscn",
	"res://Player/Forms/bishop_form.tscn",
	"res://Player/Forms/queen_form.tscn"
]

func load_form(new_form : PlayerForm.PLAYER_FORM) -> PlayerForm:
	var path : String = str(player_form_paths[new_form])
	var new_scene : PlayerForm = load(path).instantiate()
	return new_scene
	
