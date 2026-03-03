extends Node

@export var bpm : float

@export var player : AudioStreamPlayer

signal on_beat


@onready var beat_duration = 60.0 / bpm
var last_beat = -0.5
var last_position = 0.0


var time_since_last_beat: float = 0.0;
@onready var beat_length: float = 60.0 / bpm;

var beat_start_flag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.play()
	get_window().grab_focus()
	await get_tree().create_timer(0.1).timeout
	beat_start_flag = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if beat_start_flag:
		var time: float = player.get_playback_position() + AudioServer.get_time_since_last_mix();
		time -= AudioServer.get_output_latency();
		if time >= time_since_last_beat + beat_length || time < time_since_last_beat:
			#print("playback position ", player.get_playback_position(), " time since last mix ", AudioServer.get_time_since_last_mix())
			#print("output latency ", AudioServer.get_output_latency())
			#print("time ", time, " time since last beat ", time_since_last_beat)
			#print("beat");
			time_since_last_beat = time;
			on_beat.emit();
