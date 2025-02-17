extends "res://Scripts/Parts/Slot.gd"

func recoil(position_offset,x_angle,y_angle):
	translate(position_offset)
	rotate(Vector3.LEFT,x_angle)
	rotate(Vector3.UP,y_angle)
