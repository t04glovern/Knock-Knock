extends Camera3D


@export var clickable_range: float = 100
@export var gridmap: GridMap
@export var audio_knock_options: Array[AudioStream] = [
	preload("res://Audio/knock-knock1.wav"),
	preload("res://Audio/knock-knock2.wav")
]
@export var audio_torch_click_options: Array[AudioStream] = [
	preload("res://Audio/torch-click1.wav"),
	preload("res://Audio/torch-click2.wav")
]
@export var audio_godly_voice_options: Array[AudioStream] = [
	preload("res://Audio/godly-voice1.wav"),
	preload("res://Audio/godly-voice2.wav"),
	preload("res://Audio/godly-voice3.wav"),
	preload("res://Audio/godly-voice4.wav")
]
@export var audio_swish_options: Array[AudioStream] = [
	preload("res://Audio/swish1.wav"),
	preload("res://Audio/swish2.wav"),
	preload("res://Audio/swish3.wav")
]

@onready var torch_clicker_audio_stream_player: AudioStreamPlayer3D = $TorchClicker
@onready var godly_voice_audio_stream_player: AudioStreamPlayer3D = $GodlyVoice
@onready var knock_audio_stream_player: AudioStreamPlayer3D = $KnockKnock
@onready var swish_audio_stream_player: AudioStreamPlayer3D = $Swish

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var torch_light: SpotLight3D = $Torch/TorchLight

@onready var torch_light_energy: float = 1.2

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		swing_sword()
		ray_cast_3d.force_raycast_update()
		if ray_cast_3d.is_colliding():
			var collider = ray_cast_3d.get_collider()
			if collider is GridMap:
				var collision_point: Vector3 = ray_cast_3d.get_collision_point()
				var collision_point_local: Vector3 = gridmap.to_local(collision_point)
				var cell: Vector3i = gridmap.local_to_map(collision_point_local)
				var item: int = gridmap.get_cell_item(cell)
				
				if item == 0: # wall
					pass
				if item == 1: # corner-in
					pass
				if item == 2: # floor
					pass
				if item == 3: # corner-out
					pass
				if item == 4: # door
					play_knock_sound()
					play_godly_voice_sound()

	if Input.is_action_just_pressed("right_click"):
		if torch_light.light_energy > 0:
			play_torch_click_sound()
			torch_light.light_energy = 0
		else:
			play_torch_click_sound()
			torch_light.light_energy = torch_light_energy


func play_knock_sound() -> void:
	if audio_knock_options.size() > 0:
		knock_audio_stream_player.stream = audio_knock_options[randi() % audio_knock_options.size()]
		knock_audio_stream_player.play()
	else:
		print("No audio_knock_options set for KnockSound")

func play_torch_click_sound() -> void:
	if audio_torch_click_options.size() > 0:
		torch_clicker_audio_stream_player.stream = audio_torch_click_options[randi() % audio_torch_click_options.size()]
		torch_clicker_audio_stream_player.play()
	else:
		print("No audio_torch_click_options set for TorchClickSound")

func play_godly_voice_sound() -> void:
	if audio_godly_voice_options.size() > 0:
		godly_voice_audio_stream_player.stream = audio_godly_voice_options[randi() % audio_godly_voice_options.size()]
		godly_voice_audio_stream_player.play()
	else:
		print("No audio_godly_voice_options set for GodlyVoiceSound")

func play_swish_sound() -> void:
	if audio_swish_options.size() > 0:
		swish_audio_stream_player.stream = audio_swish_options[randi() % audio_swish_options.size()]
		swish_audio_stream_player.play()
	else:
		print("No audio_swish_options set for SwishSound")

func swing_sword() -> void:
	animation_player.play("attack")
	play_swish_sound()
		
func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "attack":
		animation_player.play("idle")
