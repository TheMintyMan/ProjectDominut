class_name Donut extends Mover

var max_health: int = 1
var current_health: int 
var camo: bool = false
var resistance: Global.ResistanceType = Global.ResistanceType.NONE
var cost = 0;


func _ready() -> void:
	pass

func AssignData(donutData : DonutType):
	max_health = donutData.health
	current_health = max_health
	speed = donutData.speed
	camo = donutData.camo
	resistance = donutData.resistance_type
	cost = donutData.cost
	
func DoDamage(damage):
	current_health-=damage
	if(current_health <= 0):
		OnDie()
		return true
	return false
	
func OnMoveGridCell():
	if(player != null):
		player.DonutMove(self)
