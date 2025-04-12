extends "res://Scripts/Parts/Gun.gd"

class_name HandGun

@export var recoil_potential = 5

@export var main_hand_target : Marker3D
@export var off_hand_target : Marker3D

#@onready var parent = get_parent() 

func _physics_process(delta):
	super(delta)
	if(is_attached):
		###Recoil dampening
		rotation.x = lerp(rotation.x,0.0,0.1)
		rotation.y = lerp(rotation.y,0.0,0.1)
		transform.origin = lerp(transform.origin,Vector3.ZERO,0.1)

func fire_a_shot(): #Fire the weapon, and apply recoil
	super()
	##Recoil
	var recoil = recoil_potential * (float(mass) / grip_strength)
	rotate_x(deg_to_rad(recoil))
	rotate_y(deg_to_rad(randf_range(-0.5,0.5)*recoil))
	translate(-Vector3.FORWARD*recoil/60)

func get_part_type():
	return GameData.PartType.HANDTOOL
	
func evaluate_total_inaccuracy():
	return super() + rotation_degrees.x
	
