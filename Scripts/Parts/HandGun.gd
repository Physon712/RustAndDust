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
		#var adj_angle = deg_to_rad(recoil_control)
		#var d_rotx = angle_difference(rotation.x,0)
		#var d_roty = angle_difference(rotation.y,0)
		#var adj_rotx = sign(d_rotx)*adj_angle*delta
		#var adj_roty = sign(d_roty)*adj_angle*delta
		#if(abs(adj_rotx) > abs(d_rotx)):
			#adj_rotx = d_rotx
		#if(abs(adj_roty) > abs(d_roty)):
			#adj_roty = d_roty
		#rotate_x(adj_rotx)
		#rotate_y(adj_roty)

func fire_a_shot():
	super()
	##Recoil
	var recoil = recoil_potential * (mass / grip_strength)
	rotate_x(deg_to_rad(recoil))
	rotate_y(deg_to_rad(randf_range(-0.5,0.5)*recoil))
	translate(-Vector3.FORWARD*recoil/60)
	#parent.recoil(-Vector3.FORWARD*recoil,-recoil,randf_range(-0.5,0.5)*recoil)

func get_part_type():
	return GameData.PartType.HANDTOOL
	
