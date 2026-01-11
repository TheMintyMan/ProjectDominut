extends Node

# PLAYER VALUES

const inital_currency: int = 10
var current_currency: int = inital_currency

var levels = [
	"res://art/ui/main_menu.tscn",
	"res://scenes/Map_03.tscn",
]
var level_index: int = 0

func next_level():
	level_index = (level_index + levels.size() + 1) % levels.size()
	get_tree().change_scene_to_file(levels[level_index])
	
func previous_level():
	level_index = (level_index + levels.size() - 2) % levels.size()
	get_tree().change_scene_to_file(levels[level_index])

func restart_level():
	get_tree().reload_current_scene()
