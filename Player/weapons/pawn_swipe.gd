class_name PawnSwipe extends PlayerWeapon

@onready var swipe_area : Area3D = $Area3D
@onready var  timer : Timer = $Timer

@export var swipe_duration : float = 0.1
@export var lunge_strength : float = 10

func _ready() -> void:
	timer.wait_time = swipe_duration

func shoot():
	var direction : Vector3 = (player.head.transform.basis * Vector3(0, 0, -1)).normalized()
	player.velocity.x = direction.x * player.SPEED * lunge_strength
	player.velocity.z = direction.z * player.SPEED * lunge_strength
	player.move_and_slide()
	swipe_area.visible = true
	swipe_area.monitoring = true
	timer.start()

func _on_timer_timeout() -> void:
	swipe_area.visible = false
	swipe_area.monitoring = false
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.on_hit()
