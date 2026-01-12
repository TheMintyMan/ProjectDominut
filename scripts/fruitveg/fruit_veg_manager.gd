class_name FruitVegManager extends Node3D

@export var map : Map
@export var player : Player
@export var FruitVegUnitTypes : Array[PackedScene] = []

@export var money = 0
@export var maxFruitVegs = 4
var fruitVegUnits : Array[FruitVegUnit] = []

func GetAllDonuts():
	return player.spawnedDonuts

func PointIsFruitVeg(point):
	for fv in fruitVegUnits:
		if(point in fv.gridPositions):
			return true
	return false
	
func Spawn():
	if(len(fruitVegUnits) < maxFruitVegs):
		var mapObjects = map.GetSpawnableMapObjects()
		var gridPoints : Array[int] = []
		var pointObjectMap : Dictionary[int, MapObject] = {}
		for mapObject in mapObjects:
			for point in mapObject.gridPositions:
				if(!PointIsFruitVeg(point)):
					gridPoints.append(point)
					pointObjectMap[point] = mapObject
		
		if(len(gridPoints) > 0):
			var rand = randi_range(0, len(gridPoints)-1)
			var randPos = map.CalculateXYFromGridPos(gridPoints[rand])  
			
			var newFruitVegUnit : FruitVegUnit = FruitVegUnitTypes[randi_range(0, len(FruitVegUnitTypes)-1)].instantiate()
			newFruitVegUnit.position.x = randPos[0]
			newFruitVegUnit.position.z = randPos[1]
			newFruitVegUnit.spawnable = false
			newFruitVegUnit.gridPositions.append(gridPoints[rand])
			newFruitVegUnit.manager = self
			
			pointObjectMap[gridPoints[rand]].OnSpawnedOn()
			
			map.add_child(newFruitVegUnit)
			fruitVegUnits.append(newFruitVegUnit)

func OnKill(donut : Donut):
	money+=1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(player.hasRoundStarted):
		Spawn()
	pass
