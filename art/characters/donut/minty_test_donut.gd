class_name DonutMesh extends Node3D

@export var base_donut_mesh: Array[MeshInstance3D] = []
@export var eye_r_donut_mesh: Array[MeshInstance3D] = []
@export var eye_l_donut_mesh: Array[MeshInstance3D] = []
@export var sprinkle_mesh_01: Array[MeshInstance3D] = []
@export var icing_mesh_01: Array[MeshInstance3D] = []
@export var has_sprinkles: bool = true
@export var has_icing: bool = true

var health_percent: float = 1

@export var icing_colours: Dictionary[int, Color] = {}
@export var sprinkles_colours: Dictionary[int, Color] = {}
@export var donut_colour: Dictionary[Global.ResistanceType, Color] = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if has_sprinkles: set_mesh(sprinkle_mesh_01)
	if has_icing: set_mesh(icing_mesh_01)
	set_mesh(base_donut_mesh)
	set_mesh(eye_r_donut_mesh)
	set_mesh(eye_l_donut_mesh)

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func set_mesh(mesh_list: Array[MeshInstance3D]):
	for i in range(mesh_list.size()):
		mesh_list[i].visible = false
		if health_percent <= 0.33:
			mesh_list[i].visible = i == 2
		elif health_percent <= 0.66:
			mesh_list[i].visible = i == 1
		else:
			mesh_list[i].visible =  i == 0
			

func set_health_damage(damage_percent: float):
	print ("health percent set to ", health_percent)
	health_percent = damage_percent
	
	set_mesh(base_donut_mesh)
	set_mesh(eye_r_donut_mesh)
	set_mesh(eye_l_donut_mesh)
	if has_sprinkles: set_mesh(sprinkle_mesh_01)
	if has_icing: set_mesh(icing_mesh_01)
	
func SetData(donutData : DonutType):
	for icing in icing_mesh_01:
		var mat : Material = icing.material_override.duplicate()
		mat.albedo_color = icing_colours[donutData.health_level]
		if(donutData.camo):
			mat.albedo_color.a = 0.5
		icing.material_override = mat
	
	for sprinkles in sprinkle_mesh_01:
		var mat : Material = sprinkles.material_override.duplicate()
		mat.albedo_color = sprinkles_colours[donutData.speed_level]
		if(donutData.camo):
			mat.albedo_color.a = 0.5
		sprinkles.material_override = mat
		
	for baseDonut in base_donut_mesh:
		var mat : Material = baseDonut.material_override.duplicate()
		mat.albedo_color = donut_colour[donutData.resistance_type]
		if(donutData.camo):
			mat.albedo_color.a = 0.5
		baseDonut.material_override = mat
		
		
