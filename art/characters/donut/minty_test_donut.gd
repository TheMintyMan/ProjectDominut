extends Node3D

@export var sprinkle_mesh: MeshInstance3D
@export var icing_mesh: MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprinkle_mesh.visible = false
	icing_mesh.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
