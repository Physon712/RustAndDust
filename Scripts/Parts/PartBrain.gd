extends "res://Scripts/Parts/RobotPart.gd"

class_name Brain

@export var team_signature = GameData.Faction.NEUTRAL
@export var ai_color : Color = Color.RED

@export var can_be_leader = false

func attach():
	super()
	if(robot != null):
		robot.brain = self

func _process(_delta: float) -> void:
	super(_delta)
	if(robot == null):
		return
func _physics_process(_delta: float) -> void:
	if(robot == null):
		return

func get_part_type():
	return GameData.PartType.BRAIN
	
func sense_damage(_damage:float,_responsible:Robot):
	pass
