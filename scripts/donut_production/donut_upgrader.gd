extends Resource
class_name DonutUpgrader

@export var health_cost: int = 1
@export var speed_cost: int = 1
@export var camo_cost: int = 1
@export var resistance_cost: int = 1

var health_level: int = 0
var speed_level: int = 0
var camo_level: int = 0

var resistance_levels: Dictionary = {}

func get_total_cost() -> int:
	var cost := health_cost * health_level + speed_cost * speed_level + camo_cost * camo_level
	for r_type in resistance_levels.keys():
		cost += resistance_cost * resistance_levels[r_type]
	return cost

func apply_to(donut):
	add_health(donut, health_cost * health_level)
	add_speed(donut, speed_cost * speed_level)
	if camo_level > 0:
		add_camo(donut)

	for r_type in resistance_levels.keys():
		var level = resistance_levels[r_type]
		for i in range(level):
			toggle_resistance(donut, r_type)

func add_health(donut, amount: int):
	if "max_health" in donut:
		donut.max_health += amount

func add_speed(donut, amount: float):
	if "speed" in donut:
		donut.speed += amount

func add_camo(donut):
	if "camo" in donut:
		donut.camo = true

func toggle_resistance(donut, type: int):
	if "resistances" in donut:
		if type in donut.resistances:
			donut.resistances.erase(type)
		else:
			donut.resistances.append(type)
