extends Node3D

@export var hover_height := 0.25
@export var base_hover_speed := 2.0
@export var base_rotation_speed := 45.0
@export var actual_coin_value := 200
var temp_coin_value : int

@export var respawn_per_turn : int = 3
@export var spawn_round: int = 1

@export var sound_player_node: NodePath

var hover_speed := 0.0
var rotation_speed := 0.0
var time := 0.0
var start_position: Vector3
var player

var already_spawned: bool = false

@onready var audio: AudioStreamPlayer = (
	get_node(sound_player_node)
	if sound_player_node != NodePath("")
	else null
)

func _ready():
	player = Global.GetPlayer()
	start_position = position
	disable_coin()
	spawn_round += 1
	if spawn_round == 1:
		spawn()
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
	
	if (!already_spawned):
		if(player.hasRoundStarted):
			already_spawned = true

	if (already_spawned):
		if (!player.hasRoundStarted):
			if (spawn_round == player.GetRound()):
				spawn()
				already_spawned = false

func disable_coin():
	self.visible = false
	actual_coin_value = 0

func spawn():
	self.visible = true
	actual_coin_value = temp_coin_value

func play_sound():
	if audio == null:
		push_error("AudioStreamPlayer not found. Check sound_player_node.")
		return

	if audio.playing:
		return

	audio.pitch_scale = randf_range(0.95, 1.05)
	audio.play()


func _on_area_3d_area_entered(area: Area3D) -> void: 
	
	if area.get_parent() is Donut:
		player.AddMoney(actual_coin_value)
		print ("collected")
		queue_free()
	pass # Replace with function body.
