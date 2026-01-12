class_name FruitVegArea extends FruitVegUnit

@export var projectilePrefab : PackedScene

func AttemptAttack():
	super()
	var inRangeCount : int = 0
	for child in manager.GetAllDonuts():
		var dist = position.distance_squared_to(child.position)
		if(dist <= attackDistance*attackDistance ):
			inRangeCount+=1
			var kill = HitDonut(child)
			if(kill):
				manager.OnKill(child)
	
	if(inRangeCount > 0):
		CreateProjectile(20, Vector2(0,1), 0.2)
		CreateProjectile(20, Vector2(0.5,0.5), 0.2)
		CreateProjectile(20, Vector2(1,0), 0.2)
		CreateProjectile(20, Vector2(0.5,-0.5), 0.2)
		CreateProjectile(20, Vector2(0,-1), 0.2)
		CreateProjectile(20, Vector2(-0.5,-0.5), 0.2)
		CreateProjectile(20, Vector2(-1,0), 0.2)
		CreateProjectile(20, Vector2(-0.5,0.5), 0.2)
		
func CreateProjectile(speed, dir, time):
	var projectile : FruitVegAreaProjectile = projectilePrefab.instantiate()
	manager.map.add_child(projectile)
	projectile.Shoot(speed, global_position, dir, time)			
