extends "res://Scripts/Parts/RobotPart.gd"

class_name Head

@onready var camera = $Camera3D

func _physics_process(delta):
	if(is_attached):
		global_rotation = robot.head.global_rotation
		robot.head.global_position = camera.global_position
		robot.height = robot.to_local(camera.global_position).y
