extends Resource
class_name DonutUpgrader

@export var health_cost: int = 1
@export var speed_cost: int = 1
@export var camo_cost: int = 1
@export var resistance_cost: int = 1 

func get_upgrade_cost() -> int:
	return health_cost + speed_cost + camo_cost + resistance_cost

func add_health(donut, amount: int = 5):
	donut.max_health += amount

func add_speed(donut, amount: float = 0.2):
	donut.speed += amount

func add_camo(donut):
	donut.camo = true

func add_resistance(donut, type: int):
	if type not in donut.resistances:
		donut.resistances.append(type)
