extends Resource
class_name DonutType

enum ResistanceType{
	NONE,
}

@export var speed: float = 1.0
@export var health: int = 10
@export var resistance_type: ResistanceType = ResistanceType.NONE
@export var camo: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
