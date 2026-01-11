class_name FruitVegPlacedObject extends Node3D


var shotFrom : FruitVegUnit = null
var targetPos = [0,0]
var dir = [0,0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(shotFrom != null):

		var diffX = targetPos[0]-global_position.x
		var diffY = targetPos[1]-global_position.z
		var dist = sqrt(diffX**2 + diffY**2)

		if(dist <= 0.05):
			global_position.x = targetPos[0]
			global_position.z = targetPos[1]
		else:
			global_position.x += diffX*delta
			global_position.z += diffY*delta
		
		for child in shotFrom.manager.map.GetAllChildren():
			if child is Donut:
				var projectileToDonut = global_position.distance_squared_to(child.global_position)
				
				if(projectileToDonut <= 0.9):
					print(shotFrom)
					var kill = shotFrom.HitDonut(child)
					if(kill):
						shotFrom.manager.OnKill(child)
					shotFrom = null
					queue_free()
					return
					
	else:
		queue_free()



func Shoot(fruitVegUnit, pos):
	shotFrom = fruitVegUnit
	global_position = shotFrom.global_position
	targetPos[0] = pos[0] + 0.5
	targetPos[1] = pos[1] + 0.5
