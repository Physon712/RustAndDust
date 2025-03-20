extends "res://Scripts/Parts/RobotPart.gd"

class_name Brain


func _process(delta: float) -> void:
	if(robot == null):
		return
func _physics_process(delta: float) -> void:
	if(robot == null):
		return

func get_part_type():
	return GameData.PartType.BRAIN
