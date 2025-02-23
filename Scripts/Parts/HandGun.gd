extends "res://Scripts/Parts/Gun.gd"

class_name HandGun

@export var recoil = 0.1

@export var main_hand_target : Marker3D
@export var off_hand_target : Marker3D

#@onready var parent = get_parent() 

func fire_a_shot():
	super()
	#parent.recoil(-Vector3.FORWARD*recoil,-recoil,randf_range(-0.5,0.5)*recoil)


	
