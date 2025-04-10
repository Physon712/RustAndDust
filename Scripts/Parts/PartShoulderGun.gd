extends "res://Scripts/Parts/Gun.gd"

class_name ShoulderGun

func get_part_type():
	return GameData.PartType.BACK

func _process(_delta: float) -> void:
	super(_delta)
