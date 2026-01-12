class_name Donut extends Mover

var max_health: int = 1
var current_health: int 
var camo: bool = false
var resistance: Global.ResistanceType = Global.ResistanceType.NONE
var cost = 0;

@export var donutMesh : DonutMesh 

static var instancePoolInactive : Array[Donut]

static func CreateDonutInstance(instancePrefab):
	if(len(instancePoolInactive) <= 0):
		return instancePrefab.instantiate()
	var instance = instancePoolInactive[0]
	instancePoolInactive.remove_at(0)
	return instance

func OnDie():
	super()
	Destroy();
func OnFinish():
	super()
	Destroy();

func Destroy():
	#if(get_parent() != null):
	#	get_parent().remove_child(self)
	if(active):
		player.spawnedDonuts.erase(self)
		instancePoolInactive.append(self)
		visible = false
		Reset()


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if(active):
		visible = true
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
	donutMesh.set_health_damage(1)
	
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
