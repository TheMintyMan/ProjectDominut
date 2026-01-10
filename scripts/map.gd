class_name Map extends Node3D

var mapSizeX = 16
var mapSizeY = 16
var startPoint = 0
var endPoint = 0

func CalculateXYFromGridPos(pos):
	var x = int(pos % mapSizeX)
	var y = int(pos / mapSizeX)
	return [x,y]


func GetOccupiedPoints():
	var points = []
	for child in get_children():
		if(child is MapObject):
			for point in child.gridPositions:
				points.append(CalculateXYFromGridPos(point))
	return points


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
