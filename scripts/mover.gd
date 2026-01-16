class_name Mover extends Node3D

var currentPath : DonutPath = null
var targetGridPosition : Array[int] = [0, 0]
var startGridPosition : Array[int] = [0, 0]
var lastGridPosition : Array[int] = [0,0]
var intersectionDirection = null
var currentIntersection = null
var intersectionIgnored = []
var deadEnd = false
var alreadyTravelledPaths = []
@export var speed : float = 3
var player : Player
var active = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func Reset():
	active = false
	targetGridPosition = [0,0]
	startGridPosition = [0,0]
	lastGridPosition = [0,0]
	intersectionDirection = null
	currentIntersection = null
	currentPath = null
	intersectionIgnored = []
	deadEnd = false
	alreadyTravelledPaths = []
	player = null

	
func Start(startPath, startPos):
	Reset()
	active = true
	currentPath = startPath
	var start = currentPath.ClosestPointOnPath(startPos[0],startPos[1])
	startGridPosition[0] = start[0]
	startGridPosition[1] = start[1]
	lastGridPosition = startGridPosition
	position.x = startGridPosition[0]
	position.z = startGridPosition[1]
	
	OnStart()
	GetTarget()

func GetNonIgnoredPathsCount(checkPaths):
	var notIgnored = 0
	for path in checkPaths:
		if(path not in alreadyTravelledPaths && path not in intersectionIgnored):
			notIgnored+=1
	return notIgnored

func CascadeIgnore(path : DonutPath, dontCheck = []):
	var shouldIgnore = path.endConnectionPos == null
	if(len(path.intersectingPaths) == 0):
		shouldIgnore = false
	
	dontCheck.append(path)
	var anyChecks = false
	for p in path.intersectingPaths:
		if(p in dontCheck):
			continue
		else:
			anyChecks = true
			if(p not in alreadyTravelledPaths):
				var res = CascadeIgnore(p, dontCheck)
				if(!res[0]):
					shouldIgnore = false
				dontCheck+=res[1]
			
	if(!anyChecks):
		shouldIgnore = false
	
	if(shouldIgnore):
		AddAlreadyTravelled(path)
	return [shouldIgnore, dontCheck]

func AddAlreadyTravelled(path):
	alreadyTravelledPaths.append(path)

func GetTarget():
	AddAlreadyTravelled(currentPath)
	
	if(currentIntersection != null):
		# At intersection
		var goIntersection = randi_range(0, 1)
		var count = GetNonIgnoredPathsCount(currentPath.intersectingPaths) <= 1
		var atEnd = currentPath.IsAtEnd(targetGridPosition[0], targetGridPosition[1])
		#var goesToEnd = currentIntersection[0].endConnectionPos != null
		if(count || atEnd || goIntersection == 0):		
			CascadeIgnore(currentIntersection[0])	
			currentPath = currentIntersection[0]
			
			intersectionIgnored = []
			startGridPosition = [targetGridPosition[0], targetGridPosition[1]]
		else:
			intersectionIgnored.append(currentIntersection[0])
		
		intersectionDirection = null
		currentIntersection = null

	var closestIntersection = currentPath.ClosestIntersection(position.x,position.z, alreadyTravelledPaths+intersectionIgnored)								
	if(currentPath.endConnectionPos == null && closestIntersection != null):
		if(intersectionDirection == null):
			intersectionDirection = randi_range(0, 1)
		currentIntersection = closestIntersection[intersectionDirection]
		targetGridPosition[0] = currentIntersection[1][0] 
		targetGridPosition[1] = currentIntersection[1][1]		
	# No intersections
	else:
		var end = currentPath.GetOppositeEnd(startGridPosition[0],startGridPosition[1])
		if(currentPath.endConnectionPos != null):
			end = currentPath.endConnectionPos
			
		targetGridPosition[0] = end[0] 
		targetGridPosition[1] = end[1] 
		deadEnd = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	Move(delta)

func Move(delta : float):
	if(currentPath != null):	
		var travelDist = delta*speed
	
		
		# If travel distance is more than one cell, split movement into multiple parts
		if(travelDist > 1):
			print("Fast")
			var n = int(travelDist)
			var rem = travelDist-n
			for i in range(n):
				# Rerun move with a split delta to result in a less than 1 travelDist
				Move(1.0/speed)
			Move(rem/speed)
			return

		# Will be at the next cell
		var distToTarget = position.distance_squared_to(Vector3(targetGridPosition[0],position.y, targetGridPosition[1]))
		#if(travelDist*travelDist > distToTarget):
		#	var sqrt = sqrt(distToTarget)
		#	var rem = travelDist - sqrt
		#	Move(sqrt/speed)
		#	Move(rem/speed)
		#	return

		if(distToTarget <= travelDist*travelDist):
			position.x = targetGridPosition[0]
			position.z = targetGridPosition[1]
			print("distToTargetFinsih")	
			if(currentPath.endConnectionPos != null):
				OnMoveGridCell()
				OnFinish()	
				return
			elif(deadEnd):
				deadEnd = false
				OnDie()
			else:
				GetTarget()
				
					
		var posDiffX = targetGridPosition[0]-position.x
		var posDiffY = targetGridPosition[1]-position.z	
		var dirX = sign(posDiffX)
		var dirY = sign(posDiffY)
		position.x+=dirX*travelDist
		position.z+=dirY*travelDist
		
		var roundPos : Array[int] = [int(position.x), int(position.z)]
		if(lastGridPosition != roundPos):
			OnMoveGridCell()
			lastGridPosition = roundPos



func OnMoveGridCell():
	pass
func OnFinish():
	pass
func OnStart():
	pass			
func OnDie():
	pass			
