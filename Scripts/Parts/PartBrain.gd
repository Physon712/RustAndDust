extends "res://Scripts/Parts/RobotPart.gd"

class_name Brain

func detach():
	#The brain is lost on death
	var parent = get_parent()
	parent.remove_child(self)
	is_attached = false
	robot.attach_parts()
	queue_free()
