extends Node

# DONUT VALUES
enum ResistanceType{
	NONE,
	SHOOTER,
	AREA,
	PLACING,
	WALL,
}

const inital_currency: int = 10
var current_currency: int = inital_currency

var levels = [
	"res://art/ui/main_menu.tscn",
	"res://scenes/Map_03.tscn",
]
var level_index: int = 0

func GetPlayer() -> Node3D:
	return find_player(get_tree().root)
		
		
func find_player(node : Node):
	for child in node.get_children():
		if child is Player:
			return child
		else:
			var tempChild = find_player(child)
			if tempChild is Player:
				return tempChild
	return null

func next_level():
	level_index = (level_index + levels.size() + 1) % levels.size()
	get_tree().change_scene_to_file(levels[level_index])
	
func previous_level():
	level_index = (level_index + levels.size() - 2) % levels.size()
	get_tree().change_scene_to_file(levels[level_index])

func restart_level():
	get_tree().reload_current_scene()
