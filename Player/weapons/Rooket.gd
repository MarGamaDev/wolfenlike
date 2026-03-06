class_name Rooket extends AnimatableBody3D

@export var is_player_rocket : bool = true

var rocket_speed : float = 6.0
var rocket_accel : float = 0.1
var moving_flag : bool = true

@onready var explosion : Area3D = $ExplosionArea

func _physics_process(delta: float) -> void:
	if moving_flag:
		var direction : Vector3 = -transform.basis.z
		global_position += rocket_speed * delta * direction
		rocket_speed += rocket_accel


func _on_explode_trigger_body_entered(body: Node3D) -> void:
	print("boom!")
	explosion.monitoring = true
	moving_flag = false
	explosion.visible = true
	await get_tree().create_timer(0.4).timeout
	queue_free()


func _on_explosion_hit(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.on_hit()
