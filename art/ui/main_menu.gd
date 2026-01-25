extends Control

@export var creditsMenu : Panel
@export var mainMenu : Panel

var currentActive = mainMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	creditsMenu.position.x = mainMenu.size.x*2
	currentActive = mainMenu
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	creditsMenu.size = mainMenu.size
	
	if(currentActive == mainMenu):
		mainMenu.position.x = move_toward(mainMenu.position.x, 0, delta*5000);	
		creditsMenu.position.x = move_toward(creditsMenu.position.x, mainMenu.size.x, delta*5000);	
	else:
		creditsMenu.position.x = move_toward(creditsMenu.position.x, 0, delta*5000);	
		mainMenu.position.x = move_toward(mainMenu.position.x, -mainMenu.size.x, delta*5000);	


func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_credits_pressed() -> void:
	currentActive = creditsMenu


func _on_button_back_pressed() -> void:
	currentActive = mainMenu


func _on_button_play_button_down() -> void:
	Global.next_level()
