extends "res://Scripts/Parts/PartMovement.gd"


class_name BipedLegs

var right_leg = null
var left_leg = null
var legs = []


var right_target = global_transform.origin-Vector3.UP
var left_target = global_transform.origin-Vector3.UP

@onready var legs_center = $LegsCenter

var min_length = 0
var max_height = 0.7
var min_height = 0.35
var stride_distance = 0.1

var stepping = false;

func attach():
	super()
	legs = []
	right_leg = $SlotLegR.get_child(0)
	left_leg = $SlotLegL.get_child(0)
	
	if(right_leg != null):
		legs.append(right_leg)
	if(left_leg != null):
		legs.append(left_leg)
	
	if(legs.is_empty()): #Worst case scenario, no legs avaible
		min_length = 0.2
	else: #At least one leg
		min_length = legs[0].length
	for i in range(1,legs.size()): #All the other legs (only one though)
		min_length = min(min_length,legs[i].length)
		
	height = min_length
	min_height = min_length*0.9
	max_height = min_length
	right_target = robot.global_transform.origin+Vector3.RIGHT*min_length*0.2
	left_target = robot.global_transform.origin-Vector3.RIGHT*min_length*0.2

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(is_attached):
		if(right_leg != null): #Look for ideal foot placement
			right_target = look_for_foothold(right_leg)
		if(left_leg != null):
			left_target = look_for_foothold(left_leg)
		
		var distance_to_right_target = 0
		var distance_to_left_target = 0
		
		if(right_leg != null && right_target != null): #Measure distance from foot location to ideal foot placement
			distance_to_right_target = right_target.distance_to(right_leg.target.global_position)
		if(left_leg != null && left_target != null):
			distance_to_left_target = left_target.distance_to(left_leg.target.global_position)
		
		#Evaluate which leg to step, if needed at all
		if(right_leg != null && right_target != null && !stepping && distance_to_right_target > stride_distance && distance_to_right_target > distance_to_left_target):
			step(right_leg,right_target)	
		if(left_leg != null && left_target != null && !stepping && distance_to_left_target > stride_distance):
			step(left_leg,left_target)
		
		#Lower the the hips when going fast to make reaching the foot target easier
		height = lerp(max_height,min_height,robot.velocity.length()/robot.max_speed)
		
		#Update the foot placement to the calculated one, TODO: Move this code to the code of the leg
		if(right_leg != null):
			right_leg.local_target.global_transform.origin = right_leg.target.global_position
		if(left_leg != null):
			left_leg.local_target.global_transform.origin = left_leg.target.global_position
	
func step(leg,target): #Update the foot location to the target with an animation
	stepping = true
	var t = get_tree().create_tween()
	t.tween_property(leg.target,"global_position",leg.rest_target.global_position,leg.step_time/2)
	t.tween_property(leg.target,"global_position",target,leg.step_time/2)
	t.tween_callback(func(): stepping = false)

	
func look_for_foothold(leg):
	var space_state = get_world_3d().direct_space_state
	var dir = (leg.placement_target.global_position) + robot.velocity*1.25*leg.step_time - leg.placement_top.global_position
	var query = PhysicsRayQueryParameters3D.create(leg.placement_top.global_position,leg.placement_top.global_position + 5*dir,0b001)
	var result = space_state.intersect_ray(query)
	if(result):
		return result.position
	else:
		return  null
