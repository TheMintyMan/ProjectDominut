class_name FruitVegUnitUpgradeShooter extends FruitVegUnitUpgrade

@export var upgradePaths : Array[FruitVegUnitUpgradeShooter] = []
@export var projectileCount = 1

func GetUpgradeBranchCount():
	return len(upgradePaths)
	
func GetNextLevel(level):
	return upgradePaths[level]
