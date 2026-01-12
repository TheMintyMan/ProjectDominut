class_name Player extends Node3D

@export var map : Map
@export var donutPathPrefab : PackedScene
var selectionCube : Node3D
@export var selectionCubePrefab : PackedScene

var paths : Array[DonutPath] = []
var currentPath : DonutPath = null
var startPath : DonutPath = null
var clickHeld = false

const RAY_LENGTH = 10000.0
@onready var cam = $Camera3D
@onready var ray = $RayCast3D

var round : int = 1
var donutSpawnTime : float = 0.2
var donutSpawnTimer : float = 0
var hasRoundStarted : bool = false
var readyDonuts : Array[DonutType] = []
var spawnedDonuts : Array[Donut] = []

@export var money : int = 1000


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# CHANGE THIS FOR DONUTSSS
@export var donutPrefab : PackedScene
func StartRound():
	print("Start")
	if(!hasRoundStarted):
		if(startPath != null):
			for path in paths:
				if(path.endConnectionPos != null):	
					RoundStarted()
					return			
		hasRoundStarted = false	
	print("Cant start")

func RoundStarted():
	hasRoundStarted = true	
	spawnedDonuts.clear()
	
	for path in paths:
		path.visible = false

func NextRound():
	round+=1
	donutSpawnTimer = 0
	hasRoundStarted = false
	
	for path in paths:
		path.visible = true

func CanAfford(cost : int):
	if(hasRoundStarted):
		return false
	return cost <= money

func SpendMoney(cost : int):
	money=max(money-cost, 0)

	
		
func AddReadyDonut(donutData : DonutType):
	print("buy")
	readyDonuts.append(donutData)	

func DoesPathInterceptStart(path):
	var point = map.CalculateXYFromGridPos(map.startPoint)
	if path.IsPointOnPath(point[0], point[1]):
		return true
	return false

func DeletePath(path):
	if(startPath == path):
		startPath = null
	paths.erase(path)
	path.queue_free()

func DeletePathPoint(x, y):
	for path in paths:
		if path.IsPointOnPath(x, y):
			DeletePath(path)
	CalculatePathIntersections()		
	
func GetPathAt(x, y, offset=0):
	for path in paths:
		if path.IsPointOnPath(x, y, offset):
			return path
	return null
	
func CalculatePathIntersections():
	print("try")
	# Clear intersections
	for path in paths:
		path.intersectingPaths.clear()
				
	for p1 in paths:
		for p2 in paths:
			if(p1 != p2 && p1.InsersectsPath(p2)):
				p1.intersectingPaths.append(p2)
				print("intersect")

func DonutMove(donut : Donut):
	money+=(sqrt(donut.cost))	

func RemainingDonuts():
	return len(spawnedDonuts)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(hasRoundStarted):
		if(len(readyDonuts) > 0):
			donutSpawnTimer +=delta
			if(donutSpawnTimer >= donutSpawnTime):
				donutSpawnTimer = 0
				var donut : Donut = Donut.CreateDonutInstance(donutPrefab)
				donut.AssignData(readyDonuts[0])
				readyDonuts.remove_at(0)
				map.add_child(donut)
				spawnedDonuts.append(donut)
				donut.Start(startPath, map.CalculateXYFromGridPos(map.startPoint))
				donut.player = self
				return		
		elif(RemainingDonuts() <= 0):
			NextRound()

	
	if(selectionCube == null):
		selectionCube = selectionCubePrefab.instantiate()
		map.add_child(selectionCube)
		
		
	var mousepos = get_viewport().get_mouse_position()
	ray.global_position = cam.project_ray_origin(mousepos)
	ray.target_position = ray.global_position + cam.project_ray_normal(mousepos) * RAY_LENGTH
	ray.force_raycast_update()
	if ray.is_colliding():
		selectionCube.visible = true
		var collision_object = ray.get_collider()
		var point = ray.get_collision_point()
		point = Vector3(int(point.x), 1, int(point.z))
		
		selectionCube.position = Vector3(point.x+0.5, point.y, point.z+0.5)		
		# Path creation
		if(Input.is_action_pressed("LeftClick")):
			# First click
			if(!clickHeld):
				currentPath = donutPathPrefab.instantiate()
				map.add_child(currentPath)
				currentPath.SetStart(point.x, point.z)
				currentPath.visible = false
				paths.append(currentPath)
			# Hold
			else:
				currentPath.visible = true
				currentPath.SetEnd(point.x, point.z)
			clickHeld = true
		# Let go
		elif(clickHeld):
			currentPath.visible = true
			# If path length is invalid or intersects any map objects, it's invalid
			if(currentPath.GetLength() <1 || currentPath.AreAnyPointsOnPath(map.GetOccupiedPoints())):
				DeletePath(currentPath)
			# If it's connected to the start
			elif(DoesPathInterceptStart(currentPath)):
				if(startPath != null):
					DeletePath(currentPath)
				else:
					startPath = currentPath
			else:
				# Is intersecting a path but going on the same axis, delete
				var pathTests = currentPath.InsersectingPaths(paths)
				if(len(pathTests) == 0):
					DeletePath(currentPath)
				var direction = currentPath.Direction()
				for path in pathTests:
					var dir = path.Direction()
					if((dir[0] != 0 && direction[0] != 0) || (dir[1] != 0 && direction[1] != 0)):
						path.Extend(currentPath)
						DeletePath(currentPath)
						break
			
			var endConnection = map.CalculateXYFromGridPos(map.endPoint)
			if(currentPath.IsPointOnPath(endConnection[0], endConnection[1])):
				currentPath.endConnectionPos = endConnection
				
			CalculatePathIntersections()
			clickHeld = false
			currentPath = null
			
		elif(Input.is_action_pressed("RightClick")):	
			DeletePathPoint(point.x, point.z)		
	else:
		selectionCube.visible = false
