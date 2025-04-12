extends "res://Scripts/Parts/RobotPart.gd"

class_name Head

@onready var camera = $Camera3D

func attach():
	super()
	if(robot == null):
		return
	robot.camera = camera

func _process(_delta: float) -> void:
	super(_delta)

func _physics_process(_delta):
	if(is_attached):
		global_rotation = robot.head.global_rotation
		
		##TODO get rid of that code
		robot.head.global_position = camera.global_position
		robot.height = robot.to_local(camera.global_position).y

func get_part_type():
	return GameData.PartType.HEAD
