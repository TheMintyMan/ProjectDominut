class_name FruitVegUnit extends MapObject

@export var weakness : Global.ResistanceType = Global.ResistanceType.NONE
@export var attackTime = 1
@export var attackDamage = 1
@export var attackDistance = 4
var manager : FruitVegManager = null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnable = false
	pass # Replace with function body.

var attackTimer = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(manager.player.hasRoundStarted):
		attackTimer+=delta
		if(attackTimer >= attackTime):
			AttemptAttack()
			attackTimer = 0
		pass
	else:
		attackTimer = 0
		RoundEnd()

func RoundEnd():
	pass

func AttemptAttack():
	pass
			
func HitDonut(donut : Donut):
	if(weakness != donut.resistance):
		donut.DoDamage(attackDamage)
