class_name DonutPath extends MeshInstance3D

var startPosX : int= 0
var startPosY : int = 0
var endPosX : int = 5
var endPosY : int = 0
		
var intersectingPaths : Array[DonutPath] = []		
			
var endConnectionPos = null

		
func SetStart(startX, startY):
	startPosX = startX
	startPosY = startY 
	UpdateMesh()
	
func SetEnd(endX, endY):
	var diffX = endX-startPosX
	var diffY = endY-startPosY	
	if(abs(diffX) > abs(diffY)):
		endPosX = endX
		endPosY = startPosY 
	else:
		endPosX = startPosX
		endPosY = endY	
		
	if(startPosY == 29):
		endConnectionPos = [startPosX, startPosY]
	elif(endPosY == 29):
		endConnectionPos = [endPosX, endPosY]
	
	UpdateMesh()

func GetStart():
	return [startPosX, startPosY]
func GetEnd():
	return [endPosX, endPosY]

func GetOppositeEnd(x, y):
	if(startPosX == int(x) && startPosY == int(y)):
		return [endPosX, endPosY]
	else:
		return [startPosX, startPosY]

func IsAtEnd(x, y):
	return (startPosX == int(x) && startPosY == int(y)) || (endPosX == int(x) && endPosY == int(y))


func UpdateMesh():
	var diffX = endPosX-startPosX
	var diffY = endPosY-startPosY	
	
	scale.x = abs(diffX)+1
	scale.z = abs(diffY)+1
	
	position.x = startPosX + diffX/2.0 + 0.5
	position.y = 1
	position.z = startPosY + diffY/2.0 + 0.5

func ClosestPointOnPath(x, y):
	var shortestDist = 0
	var shortestPoint = null
	for point in GetAllPoints():
		var diffX = point[0]-x
		var diffY = point[1]-y
		var dist = diffX**2 + diffY**2
		if(shortestPoint == null || dist < shortestDist):
			shortestPoint = [point[0], point[1]]
			shortestDist = dist
	
	return shortestPoint
		


func IsPointOnPath(x, y, offset=0):
	var startX = startPosX
	var startY = startPosY
	var endX = endPosX
	var endY = endPosY
	
	if(endPosX < startPosX):
		startX = endPosX
		endX = startPosX
		
	if(endPosY < startPosY):
		startY = endPosY
		endY = startPosY
	
	var xOffset = offset
	var yOffset = offset
	var diffX = endX-startX
	var diffY = endY-startY	
	if(diffX == 0):
		xOffset = 0
	if(diffY == 0):
		yOffset = 0
			
	return x >= startX+xOffset && x <= endX-xOffset && y >= startY+yOffset && y <= endY-yOffset
	
func AreAnyPointsOnPath(points):
	for point in points:
		if(IsPointOnPath(point[0], point[1])):
			return true
	return false
	

func GetAllPoints():
	var points = []
	var diffX = endPosX-startPosX
	var diffY = endPosY-startPosY	
	if(diffX != 0):
		for x in range(startPosX, endPosX+sign(diffX), sign(diffX)):
			points.append([x, startPosY])
	else:
		for y in range(startPosY, endPosY+sign(diffY), sign(diffY)):
			points.append([startPosX, y])
			
	return points
	
func GetLength():
	return abs(endPosX-startPosX + endPosY-startPosY)
	
func InsersectsPath(otherPath : DonutPath):
	for point in GetAllPoints():
		if(otherPath.IsPointOnPath(point[0], point[1])):
			return true
	return false
	
func InsersectsAnyPaths(otherPaths):
	for path in otherPaths:
		if(path != self && InsersectsPath(path)):
			return true
	return false

func InsersectingPaths(otherPaths):
	var paths = []
	for path in otherPaths:
		if(path != self && InsersectsPath(path)):
			paths.append(path)
	return paths

func Direction():
	var diffX = endPosX-startPosX
	var diffY = endPosY-startPosY	
	return [sign(diffX), sign(diffY)]

func Extend(otherPath):
	print(otherPath.startPosX)
	print(otherPath.endPosX)
	var sx = min(startPosX, endPosX, otherPath.startPosX, otherPath.endPosX)
	var ex = max(startPosX, endPosX, otherPath.startPosX, otherPath.endPosX)
	var sy = min(startPosY, endPosY, otherPath.startPosY, otherPath.endPosY)
	var ey = max(startPosY, endPosY, otherPath.startPosY, otherPath.endPosY)
	startPosX = sx
	endPosX = ex
	startPosY = sy
	endPosY = ey
	UpdateMesh()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateMesh()
	pass # Replace with function body.

func ClosestIntersection(x, y, ignore=[]):
	var shortestDistLeft = 0
	var shortestDistRight = 0
	var closestPathLeft = null
	var closestPointLeft = []
	var closestPathRight = null
	var closestPointRight = []
	
	for point in GetAllPoints():
		for intersect in intersectingPaths:
			#intersect.visible = false
			var pointOnPath = intersect.IsPointOnPath(point[0], point[1])
			if(intersect not in ignore && pointOnPath):
				var diffX = point[0]-x
				var diffY = point[1]-y
				var dist = diffX**2 + diffY**2
				
				if(closestPathLeft == null || ((diffX < 0 || diffY < 0) && dist < shortestDistLeft)):
					closestPathLeft = intersect
					shortestDistLeft = dist
					closestPointLeft = point
				if(closestPathRight == null || ((diffX > 0 || diffY > 0) && dist < shortestDistRight)):
					closestPathRight = intersect
					shortestDistRight = dist
					closestPointRight = point
	if(closestPathLeft == null && closestPathRight == null):
		return null					
	return [[closestPathLeft, closestPointLeft], [closestPathRight, closestPointRight]]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
