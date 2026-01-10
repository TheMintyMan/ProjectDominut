@tool
class_name MapEditorTool extends Node3D


@export var map : Map
@export var labelParent : Node3D
@export var floor : Node3D	
@export var floorMesh : Node3D	
@export var floorCollider : CollisionShape3D	
@export var mapSizeX : int:
	get:
		return mapSizeX
	set(value):
		mapSizeX = value
		on_resource_changed()
@export var mapSizeY : int:
	get:
		return mapSizeY
	set(value):
		mapSizeY = value
		on_resource_changed()
		
@export var startPoint : int: 
	get:
		return startPoint
	set(value):
		startPoint = value
		on_resource_changed()		
@export var endPoint : int:
	get:
		return endPoint
	set(value):
		endPoint = value
		on_resource_changed()	
@export var startPointIndicator : Node3D = null
@export var endPointIndicator : Node3D = null		
			
		
@export var refresh : bool:
	get:
		return false
	set(value):
		on_resource_changed()
		
func CalculateXYFromGridPos(pos):
	var x = int(pos % mapSizeX)
	var y = int(pos / mapSizeX)
	return [x,y]

func on_resource_changed():
	if(!Engine.is_editor_hint()):
		return
	
	if(floorMesh != null):
		floorMesh.scale.x = mapSizeX
		floorMesh.scale.z = mapSizeY
		var material: Material = floorMesh.get_active_material(0)
		if material:
			material.uv1_scale = Vector3(mapSizeX*3, mapSizeY*2, 0)
		else:
			print("No active material found.")
	if(floor != null):
		floor.position.x = mapSizeX/2.0
		floor.position.z = mapSizeY/2.0
	if(floorCollider != null):
		floorCollider.shape.extents = Vector3(mapSizeX/2.0, 0.5, mapSizeY/2.0)
	
	if(startPointIndicator != null):
		var startPos = CalculateXYFromGridPos(startPoint)
		startPointIndicator.position.x = startPos[0]
		startPointIndicator.position.z = startPos[1]
	if(endPointIndicator != null):
		var endPos = CalculateXYFromGridPos(endPoint)
		endPointIndicator.position.x = endPos[0]
		endPointIndicator.position.z = endPos[1]

	ClearLabels()

	for x in range(mapSizeX):
		for y in range(mapSizeY):	
			var id = y*mapSizeX + x
			
			var colour = Color(0, 1, 0)
			var height = 1
			if(map != null):
				for child in GetAllChildren(map):
					# Check if the child is of the specified type
					if child is MapObject:
						for pos in child.gridPositions:
							if(pos == id):
								colour = Color(1, 0, 0)
								height = 2
								break
				
			CreateLabel(str(id), colour, Vector3(x+0.5, height, y+0.5))

	
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
	
	
func CreateLabel(name, colour, origin):
	var label_3d = Label3D.new() 
	label_3d.text = name
	label_3d.font_size = 32
	
	label_3d.modulate = colour
	label_3d.transform.origin = origin
	label_3d.billboard = true
	
	labelParent.add_child(label_3d)
func ClearLabels():
	if(labelParent == null):
		return
	# Iterate through each child
	for child in labelParent.get_children():
		# Check if the child is of the specified type
		if child is Label3D:
			# Safely delete the node at the end of the current frame
			child.queue_free()
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(Engine.is_editor_hint()):
		on_resource_changed()
	else:
		ClearLabels()
		map.mapSizeX = mapSizeX
		map.mapSizeY = mapSizeY
		map.startPoint = startPoint
		map.endPoint = endPoint
