extends Control

@export var donutUpgrader : DonutUpgrader = null
@export var player : Player = null

@export var readiedDonutsLabel : Label
@export var healthLabel : Label
@export var speedLabel : Label
@export var upgradeCostLabel : Label

@export var donutCoinsLabel : Label
@export var remainingDonutsLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	readiedDonutsLabel.text = "Your Available Donuts: " + str(len(player.readyDonuts))
	healthLabel.text = str(donutUpgrader.health_level)
	speedLabel.text = str(donutUpgrader.speed_level)
	upgradeCostLabel.text = "Upgrade Cost: " + str(donutUpgrader.get_total_cost())
	donutCoinsLabel.text = "Donut Money: " + str(player.money)
	remainingDonutsLabel.text = "Remaining Donuts: " + str(player.RemainingDonuts())
	
	
