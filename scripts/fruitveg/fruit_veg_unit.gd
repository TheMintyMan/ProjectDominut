class_name FruitVegUnit extends MapObject
var manager : FruitVegManager = null
@export var mesh : Node3D 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnable = false
	pass # Replace with function body.

var attackTimer = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(manager.player.hasRoundStarted):
		attackTimer+=delta
		if(attackTimer >= GetCurrentUpgradeLevel().attackTime):
			AttemptAttack()
			attackTimer = 0
		pass
	else:
		attackTimer = 0
		RoundEnd()

func GetCurrentUpgradeLevel():
	pass

func UpgradeLevel(direction):
	pass


func LookAt(x, y):
	if(mesh != null):
		var posDiffX = x-global_position.x
		var posDiffY = y-global_position.z	
		#var dirX = sign(posDiffX)
		#var dirY = sign(posDiffY)
		
		mesh.look_at(mesh.global_position - Vector3(posDiffX, 0, posDiffY), Vector3.UP)

func SetAttackTime(new_attackTime: int):
	attackTime = new_attackTime
	
func SetDamage(new_attackDamage: int):
	attackDamage = new_attackDamage

func SetAttackDistance(new_attackDistance: int):
	attackDistance = new_attackDistance

func RoundEnd():
	pass

func AttemptAttack():
	pass
			
func HitDonut(donut : Donut):
	if(GetCurrentUpgradeLevel().weakness != donut.resistance):
		donut.DoDamage(GetCurrentUpgradeLevel().attackDamage)
