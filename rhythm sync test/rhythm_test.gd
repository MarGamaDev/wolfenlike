extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var toggle = true
func _on_rhythm_sync_manager_on_beat() -> void:
	if toggle:
		$OmniLight3D.light_color = Color(1,0,0)
		toggle = false
	else:
		$OmniLight3D.light_color = Color(0,0,1)
		toggle = true
