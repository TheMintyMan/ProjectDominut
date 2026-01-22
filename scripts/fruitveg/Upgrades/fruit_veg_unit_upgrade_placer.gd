class_name FruitVegUnitUpgradePlacer extends FruitVegUnitUpgrade


@export var upgradePaths : Array[FruitVegUnitUpgradePlacer] = []

@export var placedCount = 1

func GetUpgradeBranchCount():
	return len(upgradePaths)
	
func GetNextLevel(level):
	return upgradePaths[level]
