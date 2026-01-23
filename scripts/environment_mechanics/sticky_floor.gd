extends Node3D


@export var speed_effect = 0.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_sticky_floor_area_area_entered(area: Area3D) -> void:
	var parent = area.get_parent()
	if parent is Donut:
		parent.speed_multiplier *= speed_effect
		print("Donut has is slowed")


func _on_sticky_floor_area_area_exited(area: Area3D) -> void:
	var parent = area.get_parent()
	if parent is Donut:
		parent.speed_multiplier /= speed_effect
		print("Donut has passed")
