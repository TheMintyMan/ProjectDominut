class_name Donut extends Mover

var max_health: int = 1
var current_health: int 
var camo: bool = false
var resistance: Global.ResistanceType = Global.ResistanceType.NONE
var cost = 0;

@export var donutMesh : DonutMesh 

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	var posDiffX = targetGridPosition[0]-position.x
	var posDiffY = targetGridPosition[1]-position.z	
	var dirX = sign(posDiffX)
	var dirY = sign(posDiffY)
	
	donutMesh.look_at(global_position - Vector3(dirX, 0, dirY).normalized(), Vector3.UP)
		

func AssignData(donutData: DonutType):
	max_health = donutData.health
	current_health = max_health
	speed = donutData.speed
	camo = donutData.camo
	resistance = donutData.resistance_type
	cost = donutData.cost
	
	donutMesh.SetData(donutData)
	
func DoDamage(damage):
	current_health-=damage
	donutMesh.set_health_damage(float(current_health)/float(max_health))
	if(current_health <= 0):
		OnDie()
		return true
	return false
	
func OnMoveGridCell():
	if(player != null):
		player.DonutMove(self)
