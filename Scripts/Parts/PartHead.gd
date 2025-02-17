extends "res://Scripts/Parts/RobotPart.gd"

func _physics_process(delta):
	if(is_attached):
		global_rotation = robot.head.global_rotation
		robot.head.global_position = global_position
