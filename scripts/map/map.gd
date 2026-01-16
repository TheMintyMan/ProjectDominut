class_name Map extends Node3D

var mapSizeX = 16
var mapSizeY = 16
var startPoint = 0
var endPoint = 0

func GetAllChildren(node = null):
	if(node == null):
		node = self
	var nodes : Array = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes = nodes + GetAllChildren(N)
		else:
			nodes.append(N)
	return nodes


func GetSpawnableMapObjects():
	var objects : Array[MapObject] = []
	for child in GetAllChildren():
		if(child is MapObject):
			if(child.spawnable):
				objects.append(child)
	return objects

func CalculateXYFromGridPos(pos):
	var x = int(pos % mapSizeX)
	var y = int(pos / mapSizeX)
	return [x,y]


func GetOccupiedPoints():
	var points = []
	for child in GetAllChildren():
		if(child is MapObject):
			for point in child.gridPositions:
				print(point)
				print(child)
				points.append(CalculateXYFromGridPos(point))
	return points

func GetStartPointXY():
	return CalculateXYFromGridPos(startPoint);
func GetEndPointXY():
	return CalculateXYFromGridPos(endPoint);
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
