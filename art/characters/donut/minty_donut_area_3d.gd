extends AnimatableBody3D

var parent: Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent() != null:
		parent = get_parent()
	else:
		print("I have no parent")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_health_damage(damage: int):
	if parent.has_method("set_health_damage"):
		parent.set_health_damage(damage)
		print("changing health")
