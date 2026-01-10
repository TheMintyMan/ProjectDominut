extends Node
class_name DonutBuyer

@export var donut_scene: PackedScene
@export var base_cost: int = 1
@export var spawn_parent: Node
@export var upgrader: DonutUpgrader

var currency: int = Global.current_currency

func can_buy() -> bool:
	return currency >= get_total_cost()

func get_total_cost() -> int:
	var cost := base_cost
	if upgrader:
		cost += upgrader.get_total_cost()
	return cost

func buy_donut() -> void:
	if not can_buy():
		return

	currency -= get_total_cost()

	var donut = donut_scene.instantiate()

	if upgrader:
		upgrader.apply_to(donut)

	spawn_parent.add_child(donut)
