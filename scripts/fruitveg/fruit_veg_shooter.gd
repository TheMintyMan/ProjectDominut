class_name FruitVegShooter extends FruitVegUnit

@export var projectilePrefab : PackedScene

func AttemptAttack():
	super()
	var closestDonut : Donut = null
	var closestDist = 0
	for child in manager.map.GetAllChildren():
		if child is Donut && child != null:
			var dist = position.distance_squared_to(child.position)
			if(dist <= attackDistance*attackDistance && (closestDonut == null || dist < closestDist)):
				closestDist = dist
				closestDonut = child
	
	if(closestDonut != null):
		var projectile : FruitVegProjectile = projectilePrefab.instantiate()
		manager.map.add_child(projectile)
		#print("Shoot")
		projectile.Shoot(30, self, closestDonut)
			
