class_name Player extends Node3D

@export var map : Map
@export var selectionCube : Node3D
@export var donutPathPrefab : PackedScene

var paths : Array[DonutPath] = []
var currentPath : DonutPath = null
var startPath : DonutPath = null

var clickHeld = false

const RAY_LENGTH = 10000.0
@onready var cam = $Camera3D
@onready var ray = $RayCast3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# CHANGE THIS FOR DONUTSSS
@export var donutPrefab : PackedScene
func StartRound():
	if(startPath != null):
		for path in paths:
			if(path.endConnectionPos != null):	
				var donut = donutPrefab.instantiate()
				map.add_child(donut)
				donut.Start(startPath, map.CalculateXYFromGridPos(map.startPoint))
				print("Start")
				return
				
	print("Cant start")


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

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mousepos = get_viewport().get_mouse_position()
	ray.global_position = cam.project_ray_origin(mousepos)
	ray.target_position = ray.global_position + cam.project_ray_normal(mousepos) * RAY_LENGTH
	ray.force_raycast_update()
	if ray.is_colliding():
		selectionCube.visible = true
		var collision_object = ray.get_collider()
		var point = ray.get_collision_point()
		point = Vector3(int(point.x), 1, int(point.z))
		selectionCube.transform.origin = Vector3(point.x+0.5, point.y, point.z+0.5)		
		
		# Path creation
		if(Input.is_action_pressed("LeftClick")):
			# First click
			if(!clickHeld):
				currentPath = donutPathPrefab.instantiate()
				map.add_child(currentPath)
				currentPath.SetStart(point.x, point.z)
				paths.append(currentPath)
			# Hold
			else:
				currentPath.SetEnd(point.x, point.z)
			clickHeld = true
		# Let go
		elif(clickHeld):
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
			if(currentPath.IsPointOnPath(endConnection[0], endConnection[0])):
				currentPath.endConnectionPos = endConnection
				
			CalculatePathIntersections()
			clickHeld = false
			currentPath = null
			
		elif(Input.is_action_pressed("RightClick")):	
			DeletePathPoint(point.x, point.z)		
	else:
		selectionCube.visible = false
