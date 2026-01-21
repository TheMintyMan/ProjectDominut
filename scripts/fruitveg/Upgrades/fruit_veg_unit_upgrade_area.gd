class_name FruitVegUnitUpgradeArea extends FruitVegUnitUpgrade


@export var upgradePaths : Array[FruitVegUnitUpgradeArea] = []

func GetUpgradeBranchCount():
	return len(upgradePaths)

func GetNextLevel(level):
	return upgradePaths[level]
