class_name MapObject extends Node3D 

@export var gridPositions : Array[int]
@export var spawnable = false
@export var disableWhenSpawnedOn = false
var gridPositionsTest : Array[int]
@export var useCenterPositionForGrid = false


func OnSpawnedOn():
	if(disableWhenSpawnedOn):
		visible = false
func OnDespawnedOn():
	if(disableWhenSpawnedOn):
		visible = true
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
