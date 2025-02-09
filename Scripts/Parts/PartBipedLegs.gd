extends "res://Scripts/Parts/RobotPart.gd"

# Called when the node enters the scene tree for the first time.

var right_leg = null
var left_leg = null
var legs = []


var right_target = global_transform.origin-Vector3.UP
var left_target = global_transform.origin-Vector3.UP

@onready var legs_center = $LegsCenter

var min_length = 0.2
var height = 0.2
var max_height = 0.7
var min_height = 0.35
var stride_distance = 0.1

var stepping = false;

func _ready() -> void:
	super()

func initialize():
	right_leg = $SlotLegR.get_child(0)
	left_leg = $SlotLegL.get_child(0)
	
	if(right_leg != null):
		legs.append(right_leg)
	if(left_leg != null):
		legs.append(left_leg)
	
	if(legs.is_empty()): #Worst case scenario, no legs avaible
		min_length = 0
		robot.max_speed = 1
		robot.move_power = 200
		robot.jump_power = 0
		robot.ground_control = 0.1
	else: #At least one leg
		min_length = legs[0].length
		robot.max_speed = legs[0].max_speed
		robot.move_power= legs[0].move_power
		robot.jump_power = legs[0].jump_power
		robot.ground_control = legs[0].ground_control
	
	for i in range(1,legs.size()): #All the other legs (only one though)
		min_length = min(min_length,legs[i].length)
		robot.max_speed = min(robot.max_speed,legs[i].max_speed)
		robot.move_power += legs[i].move_power
		robot.jump_power += legs[i].jump_power
		robot.ground_control = max(robot.ground_control,legs[i].ground_control)
		
	if(legs.size() <= 1): #Special speed penality for when one legged
		robot.max_speed = robot.max_speed/2
		
	height = min_length*0.6
	min_height = min_length*0.6
	max_height = min_length*0.8
	right_target = robot.global_transform.origin+Vector3.RIGHT*min_length*0.2
	left_target = robot.global_transform.origin-Vector3.RIGHT*min_length*0.2

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
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
	#var dir = (robot.global_transform.origin-robot.head.transform.basis.x*min_length*0.2 + robot.velocity*step_time)-legs_center.global_position
	var dir = (leg.placement_target.global_position) + robot.velocity*1.25*leg.step_time - leg.global_position
	#var query = PhysicsRayQueryParameters3D.create(legs_center.global_position,legs_center.global_position+dir*2,0b001)
	var query = PhysicsRayQueryParameters3D.create(leg.global_position,leg.global_position + 5*dir,0b001)
	var result = space_state.intersect_ray(query)
	if(result):
		return result.position
	else:
		return  null
