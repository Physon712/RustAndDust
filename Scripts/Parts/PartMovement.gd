extends "res://Scripts/Parts/RobotPart.gd"

# Called when the node enters the scene tree for the first time.

class_name MovementModule

###Stats
@export var movement_instability : float = 2.0
@export var max_speed : float = 6.0

var height = 0.2

func attach():
	super()
	if(robot != null):
		robot.movement_instability = movement_instability

func _process(_delta: float) -> void:
	super(_delta)

func get_part_type():
	return GameData.PartType.MOVEMENT
