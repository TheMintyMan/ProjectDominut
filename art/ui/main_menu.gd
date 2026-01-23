extends Control

@export var tutorialLevel : PackedScene 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_credits_pressed() -> void:
	$Camera2D.position.x = 1920


func _on_button_back_pressed() -> void:
	$Camera2D.position.x = 640


func _on_button_play_button_down() -> void:
	Global.next_level()
	
func GoToTutorial() -> void:
	if(tutorialLevel != null):
		get_tree().change_scene_to_packed(tutorialLevel)
