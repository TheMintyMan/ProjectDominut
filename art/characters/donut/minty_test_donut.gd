class_name DonutMesh extends Node3D

@export var base_donut_mesh: Array[MeshInstance3D] = []
@export var eye_r_donut_mesh: Array[MeshInstance3D] = []
@export var eye_l_donut_mesh: Array[MeshInstance3D] = []
@export var sprinkle_mesh_01: Array[MeshInstance3D] = []
@export var icing_mesh_01: Array[MeshInstance3D] = []

var health_percent: float = 1

@export var icing_colours: Dictionary[int, Color] = {}
@export var sprinkles_colours: Dictionary[int, Color] = {}
@export var donut_colour: Dictionary[Global.ResistanceType, Color] = {}

var currentDonutData : DonutType = DonutType.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func set_mesh(mesh_list: Array[MeshInstance3D], all_invis: bool):
	var index: int = 0
	if all_invis == true:
		index = 5
	elif health_percent <= 0.33:
		index = 2
	elif health_percent <= 0.66:
		index = 1
	else:
		index = 0
	for i in range(mesh_list.size()):
		mesh_list[i].visible = i == index

func set_health_damage(damage_percent: float):
	health_percent = damage_percent
	
	set_mesh(base_donut_mesh, false)
	set_mesh(eye_r_donut_mesh, false)
	set_mesh(eye_l_donut_mesh, false)
	set_mesh(sprinkle_mesh_01, currentDonutData.speed_level <= 0)
	set_mesh(icing_mesh_01, currentDonutData.health_level <= 0)
	
func SetData(donutData : DonutType):
	currentDonutData = donutData
	set_mesh(icing_mesh_01, donutData.health_level <= 0)
	set_mesh(sprinkle_mesh_01, donutData.speed_level <= 0)
	#set_mesh(base_donut_mesh, false)
	#set_mesh(eye_r_donut_mesh, false)
	#set_mesh(eye_l_donut_mesh, false)

			
	for icing in icing_mesh_01:
		var mat = icing.material_override.duplicate()
		var icingCol = icing_colours[donutData.health_level]
		if(donutData.camo):
			icingCol.a = 0.5
		mat.set_shader_parameter("albedo", icingCol) 
		icing.material_override = mat
	
	for sprinkles in sprinkle_mesh_01:
		var mat : ShaderMaterial = sprinkles.material_override.duplicate()
		var sprinklesCol = sprinkles_colours[donutData.speed_level]
		if(donutData.camo):
			sprinklesCol.a = 0.5
		mat.set_shader_parameter("albedo", sprinklesCol)
		sprinkles.material_override = mat
		
	for baseDonut in base_donut_mesh:
		var mat : ShaderMaterial = baseDonut.material_override.duplicate()
		var baseCol = donut_colour[donutData.resistance_type]
		if(donutData.camo):
			baseCol.a = 0.5
		mat.set_shader_parameter("albedo", baseCol) 
		baseDonut.material_override = mat
		
		
