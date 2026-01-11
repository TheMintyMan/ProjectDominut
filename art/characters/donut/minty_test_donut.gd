extends Node3D

@export var base_donut_mesh: Array[MeshInstance3D] = []
@export var eye_r_donut_mesh: Array[MeshInstance3D] = []
@export var eye_l_donut_mesh: Array[MeshInstance3D] = []
@export var sprinkle_mesh_01: Array[MeshInstance3D] = []
@export var icing_mesh_01: Array[MeshInstance3D] = []
@export var has_sprinkles: bool = true
@export var has_icing: bool = true

@export var max_health: int = 3
var current_health: int
var health_percent: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if has_sprinkles: set_mesh(sprinkle_mesh_01)
	if has_icing: set_mesh(icing_mesh_01)
	set_mesh(base_donut_mesh)
	set_mesh(eye_r_donut_mesh)
	set_mesh(eye_l_donut_mesh)
	print("health percent set to ", health_percent)
	
	#icing_mesh_01.visible = false
	current_health = max_health
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func set_mesh(mesh_list: Array[MeshInstance3D]):
	for i in range(mesh_list.size()):
		if health_percent == 100:
			mesh_list[0].visible = true
			if i != 0: 
				mesh_list[i].visible = false
				print("set visible off on: ", mesh_list[i].name)
		
		if health_percent != 100:
			mesh_list[i].visible = false
			if health_percent < 67 && health_percent > 34:
				mesh_list[1].visible = true
				if i != 1:
					mesh_list[i].visible = false
					print("set visible off on: ", mesh_list[i].name)
			if health_percent < 34:
				mesh_list[2].visible = true
				if i != 2:
					mesh_list[i].visible = false
					print("set visible off on: ", mesh_list[i].name)

func set_health_damage(damage_amount: int):
	
	health_percent = current_health - damage_amount
	health_percent = (health_percent / max_health) * 100
	print ("health percent set to ", health_percent)
	
	current_health -= damage_amount
	
	set_mesh(base_donut_mesh)
	set_mesh(eye_r_donut_mesh)
	set_mesh(eye_l_donut_mesh)
	if has_sprinkles: set_mesh(sprinkle_mesh_01)
	if has_icing: set_mesh(icing_mesh_01)
