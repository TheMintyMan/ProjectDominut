extends AnimatableBody3D

var speed = 10
var direction = -1
var damage_amount = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	position.z += speed * direction * delta
	#move_and_collide(-transform.basis.z * delta * speed)
	
	if position.z > 10 || position.z < -10:
		direction = 0


func _on_hit_area_3d_body_entered(body: Node3D) -> void:
	print("hit object ", body.name)
	if body.is_in_group("Donut"):
		if (body.has_method("set_health_damage")):
			body.set_health_damage(damage_amount)
			print("hit")
	pass # Replace with function body.
