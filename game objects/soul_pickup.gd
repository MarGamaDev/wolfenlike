class_name SoulPickup extends Area3D

@export var soul_type : PlayerForm.PLAYER_FORM


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.pick_up_form(soul_type)
		queue_free()
	pass
