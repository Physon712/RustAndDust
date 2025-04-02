extends "res://Scripts/Parts/RobotPart.gd"

class_name Brain

@export var team_signature = GameData.Faction.NEUTRAL

func attach():
	super()
	robot.brain = self

func _process(delta: float) -> void:
	if(robot == null):
		return
func _physics_process(delta: float) -> void:
	if(robot == null):
		return

func get_part_type():
	return GameData.PartType.BRAIN
	
func sense_damage(damage:float,responsible:Robot):
	pass
