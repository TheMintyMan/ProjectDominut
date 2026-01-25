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

@export var displayDonut : DonutMesh= null

@export var upgradeMenu : PanelContainer
@export var upgradeMenuToggleButton : Button
var menuStartPos = 0;
var menuOpen = true


func _ready() -> void:
	menuStartPos = upgradeMenu.position.x
	
	for key in health_values.keys():
		max_health_level = max(max_health_level, key)
	for key in speed_values.keys():
		max_speed_level = max(max_health_level, key)
		
	UpdateDisplayDonut()

func _process(delta: float) -> void:
	if(!menuOpen):
		upgradeMenu.position.x=move_toward(upgradeMenu.position.x, menuStartPos+upgradeMenu.size.x-25, delta*500)
	else:
		upgradeMenu.position.x=move_toward(upgradeMenu.position.x, menuStartPos, delta*500)
	
	DisplayDonutProcess(delta)

func ToggleMenu():
	menuOpen = !menuOpen
	
	if(menuOpen):
		upgradeMenuToggleButton.text = ">"
	else:
		upgradeMenuToggleButton.text = "<"

func SetResistance(index : int):
	resistance_level = Global.ResistanceType.values()[index]
	UpdateDisplayDonut()

func SetCamo(state : bool):
	camo_level = state
	UpdateDisplayDonut()


func AddHealthLevel():
	health_level=min(health_level+1, max_health_level)
	UpdateDisplayDonut()
	
func RemoveHealthLevel():
	health_level=max(health_level-1, 0)
	UpdateDisplayDonut()

func AddSpeedLevel():
	speed_level=min(speed_level+1, max_speed_level)
	UpdateDisplayDonut()
	
func RemoveSpeedLevel():
	speed_level=max(speed_level-1, 0)
	UpdateDisplayDonut()

func get_total_cost() -> int:
	var cost = base_donut_cost + health_cost[health_level] + speed_cost[speed_level] + (camo_cost * int(camo_level)) + resistance_cost[resistance_level]
	return cost

func UpdateDisplayDonut():
	if(displayDonut != null):

		displayDonut.SetData(GetDonutData())
		displayDonut.set_health_damage(1)

var displayHealth = 1
func DisplayDonutProcess(delta):
	displayDonut.rotate(Vector3.UP, delta)
	displayHealth-=delta/4
	if(displayHealth < 0):
		displayHealth = 1
	displayDonut.set_health_damage(displayHealth)

func GetDonutData():
	var donutData = DonutType.new()
	donutData.health = health_values[health_level]
	donutData.speed = speed_values[speed_level]
	donutData.camo = camo_level
	donutData.resistance_type = resistance_level
	donutData.cost = get_total_cost()
	donutData.health_level = health_level
	donutData.speed_level = speed_level
	return donutData

func CreateDonutData():
	var totalCost = get_total_cost()
	if(player.CanAfford(totalCost)):
		player.AddReadyDonut(GetDonutData())
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
