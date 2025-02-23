extends "res://Scripts/Parts/RobotPart.gd"

# Called when the node enters the scene tree for the first time.

class_name MovementModule

###Stats
@export var movement_instability = 0.1
var height = 0.2

func attach():
	super()
	robot.movement_instability = movement_instability
