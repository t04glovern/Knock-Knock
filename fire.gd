extends Node3D

@export var audio_firecrackle_options: Array[AudioStream] = [
	preload("res://Audio/fire-crack1.wav"),
	preload("res://Audio/fire-crack2.wav"),
	preload("res://Audio/fire-crack3.wav")
]
@export var audio_firebackground: AudioStream = preload("res://Audio/fire-background.wav")

@onready var audio_firebackground_stream_player: AudioStreamPlayer3D = $FireBackgroundAudio
@onready var audio_firecrackle_stream_player: AudioStreamPlayer3D = $FireCrackleAudio
@onready var crackle_timer: Timer = $CrackleTimer

func _ready() -> void:
	# Start playing the fire background sound continuously
	audio_firebackground_stream_player.stream = audio_firebackground
	audio_firebackground_stream_player.play()

	# Initialize the timer for the first crackle
	start_crackle_timer()

func start_crackle_timer() -> void:
	# Set the timer to a random interval between 1 and 3 seconds
	crackle_timer.wait_time = randf_range(1.0, 3.0)
	crackle_timer.start()

func _on_crackle_timer_timeout():
	# Choose a random fire crackle sound to play
	var random_crackle_index = randi() % audio_firecrackle_options.size()
	audio_firecrackle_stream_player.stream = audio_firecrackle_options[random_crackle_index]
	audio_firecrackle_stream_player.play()

	# Restart the timer with a new random interval
	start_crackle_timer()