extends Node3D

@export var reset_path_rounds: Array[int]= []
@export var final_round: int = 9
var player: Player
var paths: Array[DonutPath]
var already_spawned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Global.GetPlayer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	player.GetRound()
	if (!already_spawned):
		if(player.hasRoundStarted):
			already_spawned = true

	if already_spawned && !player.hasRoundStarted:
		if player.GetRound() in reset_path_rounds:
			reset_path()
			already_spawned = false

func reset_path():
	paths = player.GetPaths().duplicate()
	for path in paths:
		player.DeletePath(path)
		path.queue_free()
