class_name FruitVegUnitUpgrade extends Resource


@export var weakness : Global.ResistanceType = Global.ResistanceType.NONE
@export var attackTime : float = 1
@export var attackDamage : float = 1
@export var attackDistance : float = 4

@export var meshIndicatorPath: NodePath
var meshIndicator : Node3D = null

func GetUpgradeBranchCount():
	pass

func Start(unit):
	LoadMeshIndicator(unit)
	if(meshIndicator != null):
		meshIndicator.visible = true

func End(unit):
	LoadMeshIndicator(unit)	
	if(meshIndicator != null):
		meshIndicator.visible = false

func LoadMeshIndicator(unit):
	if(meshIndicator == null):
		meshIndicator = unit.get_node(meshIndicatorPath)

func GetNextLevel(level):
	pass
