class_name DonutUpgrader extends Control

@export var player : Player = null

@export var base_donut_cost: int = 100
@export var camo_cost: int
@export var health_cost: Dictionary[int, int] = {}
@export var speed_cost: Dictionary[int, int] = {}
@export var resistance_cost: Dictionary[Global.ResistanceType, int] = {}

@export var health_values: Dictionary[int, int] = {}
@export var speed_values: Dictionary[int, float] = {}

var health_level : int = 0
var max_health_level : int = 0
var speed_level : int = 0
var max_speed_level : int = 0
var camo_level : bool = false
var resistance_level : Global.ResistanceType = Global.ResistanceType.NONE



func _ready() -> void:
	for key in health_values.keys():
		max_health_level = max(max_health_level, key)
	for key in speed_values.keys():
		max_speed_level = max(max_health_level, key)



func SetResistance(index : int):
	resistance_level = Global.ResistanceType.values()[index]

func SetCamo(state : bool):
	camo_level = state


func AddHealthLevel():
	health_level=min(health_level+1, max_health_level)
func RemoveHealthLevel():
	health_level=max(health_level-1, 0)

func AddSpeedLevel():
	speed_level=min(speed_level+1, max_speed_level)
func RemoveSpeedLevel():
	speed_level=max(speed_level-1, 0)

func get_total_cost() -> int:
	var cost = base_donut_cost + health_cost[health_level] + speed_cost[speed_level] + (camo_cost * int(camo_level)) + resistance_cost[resistance_level]
	return cost


func CreateDonutData():
	var totalCost = get_total_cost()
	if(player.CanAfford(totalCost)):
		var donutData = DonutType.new()
		donutData.health = health_values[health_level]
		donutData.speed = speed_values[speed_level]
		donutData.camo = camo_level
		donutData.resistance_type = resistance_level
		donutData.cost = totalCost
		donutData.health_level = health_level
		donutData.speed_level = speed_level
		player.AddReadyDonut(donutData)
		player.SpendMoney(totalCost)
		return true
	return false

func CreateAllDonutData():
	if(player.money == 0):
		return
	var total = int(player.money/get_total_cost())
	for i in range(total):
		if(!CreateDonutData()):
			return
