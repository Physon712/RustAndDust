extends "res://Scripts/Parts/RobotPart.gd"

# Called when the node enters the scene tree for the first time.

var right_leg = null
var left_leg = null

var right_target = global_transform.origin-Vector3.UP
var left_target = global_transform.origin-Vector3.UP

@onready var legs_center = $LegsCenter

var min_length = 0.2
var height = 0.2
var max_height = 0.7
var step_time = 0.2
var stride_distance = 0.1

var stepping = false;

func _ready() -> void:
	super()
	initialize()

func initialize():
	right_leg = $SlotLegR.get_child(0)
	left_leg = $SlotLegL.get_child(0)
	min_length = min(right_leg.length,left_leg.length)
	height = min_length*0.6
	max_height = min_length*0.5
	right_target = robot.global_transform.origin+Vector3.RIGHT*min_length*0.2
	left_target = robot.global_transform.origin-Vector3.RIGHT*min_length*0.2
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$marker1.global_position = right_target
	var md = clamp(5-(5*$marker1.global_position.distance_to(legs_center.global_position)/min_length),0,5)
	$marker1.scale = Vector3(md,md,md)
	$marker2.global_position = left_target
	var md2 = clamp(5-(5*$marker2.global_position.distance_to(legs_center.global_position)/min_length),0,5)
	$marker2.scale = Vector3(md2,md2,md2)
	
	right_target = look_for_foothold(right_leg)
	left_target = look_for_foothold(left_leg)
	
	var distance_to_right_target = right_target.distance_to(right_leg.target.global_position)
	var distance_to_left_target = left_target.distance_to(left_leg.target.global_position)

	if(!stepping && distance_to_right_target > stride_distance && distance_to_right_target > distance_to_left_target):
		step_right()
		
	if(!stepping && distance_to_right_target > stride_distance):
		step_left()
	
	right_leg.local_target.global_transform.origin = right_leg.target.global_position
	left_leg.local_target.global_transform.origin = left_leg.target.global_position
	
func step_right(): #Update the foot location to the target with an animation
	stepping = true
	var t = get_tree().create_tween()
	t.tween_property(right_leg.target,"global_position",right_leg.rest_target.global_position,step_time/2)
	t.tween_property(right_leg.target,"global_position",right_target,step_time/2)
	t.tween_callback(func(): stepping = false)

func step_left(): #Update the foot location to the target with an animation
	stepping = true
	var t = get_tree().create_tween()
	t.tween_property(left_leg.target,"global_position",left_leg.rest_target.global_position,step_time/2)
	t.tween_property(left_leg.target,"global_position",left_target,step_time/2)
	t.tween_callback(func(): stepping = false)
	
	
func look_for_foothold(leg):
	var space_state = get_world_3d().direct_space_state
	#var dir = (robot.global_transform.origin-robot.head.transform.basis.x*min_length*0.2 + robot.velocity*step_time)-legs_center.global_position
	print(step_time*robot.velocity)
	var dir = (leg.global_position-Vector3.UP*min_length) + robot.velocity*step_time - leg.global_position
	#var query = PhysicsRayQueryParameters3D.create(legs_center.global_position,legs_center.global_position+dir*2,0b001)
	var query = PhysicsRayQueryParameters3D.create(leg.global_position,leg.global_position + 100*dir,0b001)
	var result = space_state.intersect_ray(query)
	if(result):
		return result.position
	
func lay_foot_left():
	var space_state = get_world_3d().direct_space_state
	#var dir = (robot.global_transform.origin-robot.head.transform.basis.x*min_length*0.2 + robot.velocity*step_time)-legs_center.global_position
	var dir = (left_leg.global_position-Vector3.UP*min_length) + robot.velocity*step_time - left_leg.global_position
	#var query = PhysicsRayQueryParameters3D.create(legs_center.global_position,legs_center.global_position+dir*2,0b001)
	var query = PhysicsRayQueryParameters3D.create(left_leg.global_position,left_leg.global_position + dir,0b001)
	var result = space_state.intersect_ray(query)
	if(result):
		left_target = result.position
		step_left()
	#else:
		#left_leg.target.global_transform.origin = left_leg.rest_target.global_transform.origin

		
func lay_foot_right():
	var space_state = get_world_3d().direct_space_state
	#var dir = (robot.global_transform.origin+robot.head.transform.basis.x*min_length*0.2 + robot.velocity*step_time)-legs_center.global_position
	var dir = (right_leg.global_position-Vector3.UP*min_length) + robot.velocity*step_time - right_leg.global_position
	#var query = PhysicsRayQueryParameters3D.create(legs_center.global_position,legs_center.global_position+dir*2,0b001)
	var query = PhysicsRayQueryParameters3D.create(right_leg.global_position,right_leg.global_position + dir,0b001)
	var result = space_state.intersect_ray(query)
	if(result):
		right_target = result.position
		step_right()
	#else:
		#right_leg.target.global_transform.origin = right_leg.rest_target.global_transform.origin
		
#func lay_leg(leg, target): #Will try to lay the feet on the ground toward the target
	#var space_state = get_world_3d().direct_space_state
	#var dir = target-leg.global_transform.origin
	#if(leg == leftleg):
		#$marker1.global_position = leg.global_transform.origin+dir*0.5*min_length
		#$marker2.global_position = leg.global_transform.origin+dir*1*min_length
		#$marker3.global_position = leg.global_transform.origin+dir*1.5*min_length
	#var query = PhysicsRayQueryParameters3D.create(leg.global_transform.origin, leg.global_transform.origin+dir*2*min_length,0b001)
	#var result = space_state.intersect_ray(query)
	#if(result):
		#leg.target.global_transform.origin = result.position
		#return result.position
	#else:
		#leg.target.global_transform = leg.rest_target.global_transform
		#return leg.rest_target.global_transform.origin
		#
