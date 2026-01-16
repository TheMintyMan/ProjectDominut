class_name FruitVegProjectile extends Node3D

var speed : float = 10
var shotFrom : FruitVegUnit = null
var target : Donut = null
@export var mesh : Node3D 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(shotFrom != null && target != null):	
		var meshDir = target.global_position-mesh.global_position
		mesh.look_at(mesh.global_position - meshDir, Vector3.UP)
	
		var dir = (target.global_position-shotFrom.global_position).normalized()
		global_position+=dir*delta*speed
		global_position.y = 1
		
		var vegToProjectile = global_position.distance_squared_to(shotFrom.global_position)
		var vegToTarget = shotFrom.global_position.distance_squared_to(target.global_position)
		if(vegToTarget <= vegToProjectile):
			var kill = shotFrom.HitDonut(target)
			if(kill):
				shotFrom.manager.OnKill(target)
			shotFrom = null
			queue_free()
	else:
		queue_free()


func Shoot(projectileSpeed, fruitVegUnit, donut):
	speed = projectileSpeed
	shotFrom = fruitVegUnit
	position = shotFrom.global_position
	target = donut
