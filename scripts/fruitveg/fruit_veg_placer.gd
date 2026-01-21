class_name FruitVegPlacer extends FruitVegUnit

@export var placedPrefab : PackedScene
var spawnedObjects : Array[FruitVegPlacedObject] = []

@export var upgrades : FruitVegUnitUpgradePlacer 
@export var currentLevel : Array[int] = []

func GetCurrentUpgradeLevel():
	var upgrade : FruitVegUnitUpgrade  = upgrades
	for level in currentLevel:
		upgrade.End(self)
		upgrade = upgrade.GetNextLevel(level)
		upgrade.Start(self)
	return upgrade
	
func UpgradeLevel(direction):
	var upgrade = GetCurrentUpgradeLevel()
	var paths = upgrade.GetUpgradeBranchCount()
	if(paths != 0):
		var bounded = clampi(direction, 0, paths)
		currentLevel.append(bounded)
		
func RandomUpgrade():
	var paths = GetCurrentUpgradeLevel().GetUpgradeBranchCount()
	var rand = randi_range(0, len(paths)-1)
	UpgradeLevel(rand)
		
func AttemptAttack():
	super()
	print(global_position)
	var pathPoints = []
	for child in manager.map.GetAllChildren():
		if child != null && child is DonutPath:
			for point in child.GetAllPoints():

				var distX = global_position.x-point[0]
				var distY = global_position.z-point[1]
				var dist = distX**2 + distY**2
				var attackDistance = GetCurrentUpgradeLevel().attackDistance
				if(dist <= attackDistance*attackDistance):
					pathPoints.append(point)
	
	if(len(pathPoints) > 0):
		var randPoint = pathPoints[randi_range(0, len(pathPoints)-1)]
		
		var placedObject : FruitVegPlacedObject = placedPrefab.instantiate()
		manager.map.add_child(placedObject)
		#print("Shoot")
		placedObject.Shoot(self, randPoint)
		LookAt(randPoint[0], randPoint[1])
		spawnedObjects.append(placedObject)


func RoundEnd():
	for object in spawnedObjects:
		if(object != null):
			object.queue_free()
	spawnedObjects.clear()	
