class_name FruitVegAreaProjectile extends Node3D

var speed : float = 10
var dir : Vector2
var aliveTime = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	aliveTime-=delta
	if(aliveTime <= 0):
		queue_free()
	else:
		global_position = Vector3(global_position.x + dir.x, 1, global_position.z + dir.y)


func Shoot(projectileSpeed, startPos, direction, time):
	speed = projectileSpeed
	dir = direction
	aliveTime = time
	global_position = startPos
