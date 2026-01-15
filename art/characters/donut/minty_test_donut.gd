class_name DonutMesh extends Node3D

@export var base_donut_mesh: Array[MeshInstance3D] = []
@export var eye_r_donut_mesh: Array[MeshInstance3D] = []
@export var eye_l_donut_mesh: Array[MeshInstance3D] = []
@export var sprinkle_mesh_01: Array[MeshInstance3D] = []
@export var icing_mesh_01: Array[MeshInstance3D] = []
var has_sprinkles: bool = false
var has_icing: bool = false

var health_percent: float = 1

@export var icing_colours: Dictionary[int, Color] = {}
@export var sprinkles_colours: Dictionary[int, Color] = {}
@export var donut_colour: Dictionary[Global.ResistanceType, Color] = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_mesh(sprinkle_mesh_01, true)
	set_mesh(icing_mesh_01, true)
	set_mesh(base_donut_mesh, false)
	set_mesh(eye_r_donut_mesh, false)
	set_mesh(eye_l_donut_mesh, false)

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
	print ("health percent set to ", health_percent)
	health_percent = damage_percent
	
	set_mesh(base_donut_mesh, false)
	set_mesh(eye_r_donut_mesh, false)
	set_mesh(eye_l_donut_mesh, false)
	if has_sprinkles: set_mesh(sprinkle_mesh_01, false)
	if has_icing: set_mesh(icing_mesh_01, false)
	
func SetData(donutData : DonutType):
	for icing in icing_mesh_01:
		var mat = icing.material_override.duplicate()
		mat.set_shader_parameter("albedo", icing_colours[donutData.health_level]) 
		if(donutData.camo):
			mat.albedo.a = 0.5
		icing.material_override = mat
	
	for sprinkles in sprinkle_mesh_01:
		var mat : ShaderMaterial = sprinkles.material_override.duplicate()
		mat.set_shader_parameter("albedo", sprinkles_colours[donutData.speed_level])
		if(donutData.camo):
			mat.albedo.a = 0.5
		sprinkles.material_override = mat
		
	for baseDonut in base_donut_mesh:
		var mat : ShaderMaterial = baseDonut.material_override.duplicate()
		mat.set_shader_parameter("albedo", donut_colour[donutData.resistance_type]) 
		if(donutData.camo):
			mat.albedo.a = 0.5
		baseDonut.material_override = mat
		
		
