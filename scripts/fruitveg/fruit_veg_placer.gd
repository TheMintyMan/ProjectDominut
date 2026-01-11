class_name FruitVegPlacer extends FruitVegUnit

@export var placedPrefab : PackedScene
var spawnedObjects : Array[FruitVegPlacedObject] = []

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
				#print(str(distX) + " " + str(distY))
				print(attackDistance*attackDistance)
				if(dist <= attackDistance*attackDistance):
					pathPoints.append(point)
	
	if(len(pathPoints) > 0):
		var randPoint = pathPoints[randi_range(0, len(pathPoints)-1)]
		
		var placedObject : FruitVegPlacedObject = placedPrefab.instantiate()
		manager.map.add_child(placedObject)
		#print("Shoot")
		placedObject.Shoot(self, randPoint)
		spawnedObjects.append(placedObject)

func RoundEnd():
	for object in spawnedObjects:
		if(object != null):
			object.queue_free()
	spawnedObjects.clear()	
