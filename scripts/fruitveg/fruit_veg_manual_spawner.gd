extends Node3D

@export var map : Map
@export var player : Player
@export var manager : FruitVegManager
@export var fruit_veg : PackedScene
@export var default_attackTime = 1
@export var default_attackDamage = 1
@export var default_attackDistance = 4
@export var spawn_round: int = 1 # Needs reference to round manager
@export var upgrade_rounds: Array[int] = []
@export var removal_round: int = 0 # IF you want to remove this tower at somepoint
var spawn_point: int = 0
var already_spawned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_round += 1
	%MeshInstance3D.visible = false
	if spawn_round == 1:
		spawn()
	pass

func spawn():
	spawn_point = map.CalculatePosFromWorld(self)
	if spawn_round != player.GetRound():
		return
	
	var unit : FruitVegUnit = fruit_veg.instantiate()
	
	unit.position = map.CalculateGridPosToWOrld(spawn_point)
	unit.spawnable = false
	unit.manager = manager
	unit.SetAttackDistance(default_attackDistance)
	unit.SetAttackTime(default_attackTime)
	unit.SetDamage(default_attackDamage)
	#unit.visible = true
	
	map.add_child(unit)

func upgrade():
	pass
	
func die():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _process(_delta: float) -> void:
	if (!already_spawned):
		if(player.hasRoundStarted):
			already_spawned = true

	if (already_spawned):
		if (!player.hasRoundStarted):
			if (spawn_round == player.GetRound()):
				spawn()
				already_spawned = false
				# this is the end of the round.
