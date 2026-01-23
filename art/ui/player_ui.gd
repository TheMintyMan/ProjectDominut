extends Control

@export var donutUpgrader : DonutUpgrader = null
@export var player : Player = null

@export var readiedDonutsLabel : Label
@export var healthLabel : Label
@export var speedLabel : Label
@export var upgradeCostLabel : Label

@export var donutCoinsLabel : Label
@export var remainingDonutsLabel : Label
@export var counterHealthLabel : Label
@export var currentRoundLabel : Label

@export var winScreen : Control
@export var loseScreen : Control
@export var pauseScreen : Control

@export var mainMenuScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass # Replace with function body.
	
func _exit_tree():
	get_tree().paused = false

func _process(delta: float) -> void:
	$debug.text = str(Engine.get_frames_per_second())
	readiedDonutsLabel.text = "Your Available Donuts: " + str(len(player.readyDonuts))
	healthLabel.text = str(donutUpgrader.health_level)
	speedLabel.text = str(donutUpgrader.speed_level)
	upgradeCostLabel.text = "Upgrade Cost: " + str(donutUpgrader.get_total_cost())
	donutCoinsLabel.text = "Donut Money: " + str(player.money)
	remainingDonutsLabel.text = "Remaining Donuts: " + str(player.RemainingDonuts())
	counterHealthLabel.text = "Remaining Counter Health: " + str(player.map.counterHealth)
	currentRoundLabel.text = "Round: " + str(player.round) + "/" + str(player.maxRounds)
	
	if(Input.is_action_just_released("Pause")):
		pauseScreen.visible = !pauseScreen.visible
		get_tree().paused = pauseScreen.visible

	
	winScreen.visible = player.winState == Player.WinState.WIN && !pauseScreen.visible
	loseScreen.visible = player.winState == Player.WinState.LOSE && !pauseScreen.visible
	
	
	


func RestartCurrentLevel():
	get_tree().reload_current_scene()
	
func GoToMainMenu():
	get_tree().change_scene_to_packed(mainMenuScene)
		
	
