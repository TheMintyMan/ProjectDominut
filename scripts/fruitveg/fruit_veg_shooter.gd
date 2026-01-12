class_name FruitVegShooter extends FruitVegUnit

@export var projectilePrefab : PackedScene

func _physics_process(delta: float) -> void:
	super(delta)
	var closestDonut : Donut = null
	var closestDist = 0
	for child in manager.GetAllDonuts():
		var dist = position.distance_squared_to(child.position)
		if(closestDonut == null || dist < closestDist):
			closestDist = dist
			closestDonut = child
	
	if(closestDonut != null):
		LookAt(closestDonut.global_position.x, closestDonut.global_position.z)
	

func AttemptAttack():
	super()
	var closestDonut : Donut = null
	var closestDist = 0
	for child in manager.GetAllDonuts():
		var dist = position.distance_squared_to(child.position)
		if(dist <= attackDistance*attackDistance && (closestDonut == null || dist < closestDist)):
			closestDist = dist
			closestDonut = child
	
	if(closestDonut != null):
		LookAt(closestDonut.global_position.x, closestDonut.global_position.z)
		var projectile : FruitVegProjectile = projectilePrefab.instantiate()
		manager.map.add_child(projectile)
		#print("Shoot")
		projectile.Shoot(30, self, closestDonut)
			
