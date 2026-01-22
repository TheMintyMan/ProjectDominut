class_name FruitVegArea extends FruitVegUnit

@export var projectilePrefab : PackedScene
@export var projectileAliveTime : float = 0.2

@export var upgrades : FruitVegUnitUpgradeArea
@export var currentLevel : Array[int] = []

func GetCurrentUpgradeLevel():
	var upgrade : FruitVegUnitUpgrade  = upgrades
	for level in currentLevel:
		upgrade.End(self)
		upgrade = upgrade.GetNextLevel(level)
		upgrade.Start(self)
	return upgrade
	
func UpgradeLevel(direction):
	var upgrade = GetCurrentUpgradeLevel()
	var paths = upgrade.GetUpgradeBranchCount()
	if(paths != 0):
		var bounded = clampi(direction, 0, paths)
		currentLevel.append(bounded)
		return true
	else:
		return false
	
func RandomUpgrade():
	var paths = GetCurrentUpgradeLevel().GetUpgradeBranchCount()
	var rand = randi_range(0, paths-1)
	return UpgradeLevel(rand)

			
func AttemptAttack():
	super()
	var inRangeCount : int = 0
	for child in manager.GetAllDonuts():
		var dist = position.distance_squared_to(child.position)
		var attackDistance = GetCurrentUpgradeLevel().attackDistance
		if(dist <= attackDistance*attackDistance ):
			inRangeCount+=1
			var kill = HitDonut(child)
			if(kill):
				manager.OnKill(child)
	
	if(inRangeCount > 0):
		CreateProjectile(20, Vector2(0,1), projectileAliveTime)
		CreateProjectile(20, Vector2(0.5,0.5), projectileAliveTime)
		CreateProjectile(20, Vector2(1,0), projectileAliveTime)
		CreateProjectile(20, Vector2(0.5,-0.5), projectileAliveTime)
		CreateProjectile(20, Vector2(0,-1), projectileAliveTime)
		CreateProjectile(20, Vector2(-0.5,-0.5), projectileAliveTime)
		CreateProjectile(20, Vector2(-1,0), projectileAliveTime)
		CreateProjectile(20, Vector2(-0.5,0.5), projectileAliveTime)
		
func CreateProjectile(speed, dir, time):
	var projectile : FruitVegAreaProjectile = projectilePrefab.instantiate()
	manager.map.add_child(projectile)
	projectile.Shoot(speed, global_position, dir, time)			
