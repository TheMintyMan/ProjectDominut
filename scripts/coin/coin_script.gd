extends Node3D

@export var hover_height := 0.25
@export var base_hover_speed := 2.0
@export var base_rotation_speed := 45.0

@export var sound_player_node: NodePath

var hover_speed := 0.0
var rotation_speed := 0.0
var time := 0.0
var start_position: Vector3

@onready var audio: AudioStreamPlayer = (
	get_node(sound_player_node)
	if sound_player_node != NodePath("")
	else null
)


func _ready():
	start_position = position

	# Randomize per-instance
	hover_speed = base_hover_speed * randf_range(0.75, 1.25)
	rotation_speed = base_rotation_speed * randf_range(0.75, 1.25)

	# Random phase offset
	time = randf() * TAU

	play_sound()

func _process(delta):
	time += delta

	var offset = sin(time * hover_speed) * hover_height
	position.y = start_position.y + offset

	rotate_y(deg_to_rad(rotation_speed) * delta)


func play_sound():
	if audio == null:
		push_error("AudioStreamPlayer not found. Check sound_player_node.")
		return

	if audio.playing:
		return

	audio.pitch_scale = randf_range(0.95, 1.05)
	audio.play()
