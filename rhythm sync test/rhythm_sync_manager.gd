extends Node

@export var bpm : float

@export var player : AudioStreamPlayer

signal on_beat

var time

@onready var beat_duration = 60.0 / bpm
@onready var current_beat = 0
var last_beat = -0.5
var last_position = 0.0
var loop_buffer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var current_position = player.get_playback_position()
	
	if current_position < last_position:
		print("looped!")
		current_beat = 0
		var last_beat = -0.5
		loop_buffer = time
	
	time = current_position + AudioServer.get_time_since_last_mix() + loop_buffer
	time -= AudioServer.get_output_latency() 
	var time_check = time / beat_duration
	if step_decimals(time_check)!=1 && (current_beat < time_check) &&(time - last_beat > 0.1): 
		#print(current_beat)
		#print(time_check)
		print("beat")
		on_beat.emit()
		#print(last_beat)
		current_beat += beat_duration
		last_beat = time
	last_position = current_position
