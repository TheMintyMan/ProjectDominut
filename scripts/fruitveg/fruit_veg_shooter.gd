class_name FruitVegShooter extends FruitVegUnit

@export var projectilePrefab : PackedScene

@export var upgrades : FruitVegUnitUpgradeShooter
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
	var upgrade = GetCurrentUpgradeLevel()
	var attackDistance = upgrade.attackDistance
	var closestDonuts : Array[Donut] = []
	var closestDonutsDists : Array[float] = []
	for child in manager.GetAllDonuts():
		var dist = position.distance_squared_to(child.position)
		if(dist <= attackDistance*attackDistance):
			if(len(closestDonuts) == 0):
				closestDonuts.append(child)
				closestDonutsDists.append(dist)
				
			for i in range(len(closestDonuts)):
				if(i == len(closestDonuts)-1):
					closestDonuts.append(child)
					closestDonutsDists.append(dist)
					break
				elif(dist < closestDonutsDists[i]):
					closestDonuts.insert(i, child)
					closestDonutsDists.insert(i, dist)
					break
	
	if(len(closestDonuts) > 0):
		var count = 0
		var index = 0
		while(count < upgrade.projectileCount):
			var donut = closestDonuts[index]
			LookAt(donut.global_position.x, donut.global_position.z)
			var projectile : FruitVegProjectile = projectilePrefab.instantiate()
			manager.map.add_child(projectile)
			#print("Shoot")
			projectile.Shoot(30, self, donut)
			count+=1
			
			index+=1
			if(index >= len(closestDonuts)):
				index = 0
