extends "res://Scripts/Parts/RobotPart.gd"

class_name Weapon

var inaccuracy = 0
var grip_strength = 0

###Stats
func use(): #Interface function, use = fire for firearm, swing = melee weapon
	pass

func evaluate_total_inaccuracy():
	return inaccuracy+robot.inaccuracy
