class_name KnightForm extends PlayerForm

@export var starting_soul : int = 10
@export var knight_slam_damage : float = 10

##do once grid system is in game
func initialize(set_player : Player) -> void:
	super(set_player)
	#weapon = load("res://Player/weapons/king_pistol.tscn").instantiate()
	#player.get_weapon_holder().add_child(weapon)
	attack_soul_consumption = 0
	player_form = PLAYER_FORM.KNIGHT
	player.set_soul(starting_soul)
