extends Node3D

@export var direction : Vector3
@export var speed : float = 1
@export var distance : float = 0.5
@export var canBobBackwards = false

var totalTime = 0

var startPos : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startPos = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	totalTime+=delta*speed
	var sin = sin(totalTime)
	if(!canBobBackwards):
		sin = max(sin, 0)
	global_position = startPos + direction * sin * distance
	pass
