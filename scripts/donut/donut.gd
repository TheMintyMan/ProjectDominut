extends Node3D
class_name Donut

@export var donut_type: DonutType

var current_health : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if donut_type == null:
		push_error("Donut has no DonutType assigned!")
		return

	current_health = donut_type.health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
