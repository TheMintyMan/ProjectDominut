extends Node3D
class_name Donut

@export var donut_type: DonutType

var max_health: int
var current_health: int
var speed: float
var camo: bool = false
var resistances: Array[int] = []

func _ready() -> void:
	if donut_type == null:
		push_error("Donut has no DonutType assigned!")
		return

	max_health = donut_type.health
	current_health = max_health
	speed = donut_type.speed
	camo = donut_type.camo
	resistances = donut_type.resistances.duplicate()
