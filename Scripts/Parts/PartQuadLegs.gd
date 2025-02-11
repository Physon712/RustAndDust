extends "res://Scripts/Parts/RobotPart.gd"

### Must have 4 slots for 4 legs (FR, FL, BR, BL)

var fright_leg = null
var fleft_leg = null

var bright_leg = null
var bleft_leg = null

var legs = []
var opposite_index = []
var leg_count = 4
var legs_targets = []

var min_length = 0.2
var height = 0.2
var max_height = 0.7
var min_height = 0.35
var stride_distance = 0.1

var stepping = false;

func _ready() -> void:
	super()

func attach():
	super()
	if($SlotLegFR.get_child_count() > 0):
		fright_leg = $SlotLegFR.get_child(0)
	if($SlotLegFL.get_child_count() > 0):
		fleft_leg = $SlotLegFL.get_child(0)
	if($SlotLegBR.get_child_count() > 0):
		bright_leg = $SlotLegBR.get_child(0)
	if($SlotLegBL.get_child_count() > 0):
		bleft_leg = $SlotLegBL.get_child(0)
	
	if(fright_leg != null):
		legs.append(fright_leg)
		legs_targets.append(fright_leg.rest_target.global_position)

	if(bleft_leg != null):
		legs.append(bleft_leg)
		legs_targets.append(bleft_leg.rest_target.global_position)
		
	if(fleft_leg != null):
		legs.append(fleft_leg)
		legs_targets.append(fleft_leg.rest_target.global_position)
		
	if(bright_leg != null):
		legs.append(bright_leg)
		legs_targets.append(bright_leg.rest_target.global_position)
		
	#Establishing opposite from each leg once we got all the legs accounted for
	opposite_index.append(legs.find(bleft_leg))
	opposite_index.append(legs.find(fright_leg))
	opposite_index.append(legs.find(bright_leg))
	opposite_index.append(legs.find(fleft_leg))
		
	leg_count = legs.size()
	
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
		
	if(legs.size() <= 2): #Special speed penality for when two legged
		robot.max_speed = robot.max_speed/2
		if(legs.size() <= 1): #Special speed penality for when two legged
			robot.max_speed = robot.max_speed/2
		
	height = min_length*0.6
	min_height = min_length*0.6
	max_height = min_length*0.8

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(!is_attached):
		pass
	
	for i in range(leg_count):
		legs_targets[i] = look_for_foothold(legs[i])
	
	var distances_to_targets = []
	for i in range(leg_count):
		distances_to_targets.append(0)
	
	for i in range(leg_count):
		if(legs_targets[i] != null):
			distances_to_targets[i] = legs_targets[i].distance_to(legs[i].target.global_position)
		
	#Evaluate which leg to step, if needed at all
	var maximum_distance = 0
	var maximum_index = 0
	for i in range(leg_count):
		if(maximum_distance < distances_to_targets[i]):
			maximum_distance = distances_to_targets[i]
			maximum_index = i
	
	if(!stepping && maximum_distance > stride_distance):
		step(legs[maximum_index],legs_targets[maximum_index])
		if(opposite_index[maximum_index] != -1 && legs_targets[opposite_index[maximum_index]] != null): #We also step the opposite leg for a more natural look
			step(legs[opposite_index[maximum_index]],legs_targets[opposite_index[maximum_index]])
	
	#Lower the the hips when going fast to make reaching the foot target easier
	height = lerp(max_height,min_height,robot.velocity.length()/robot.max_speed)
	
	#Update the foot placement to the calculated one, TODO: Move this code to the code of the leg
	for i in range(leg_count):
		legs[i].local_target.global_transform.origin = legs[i].target.global_position
	
func step(leg,target): #Update the foot location to the target with an animation
	print("stepping")
	stepping = true
	var t = get_tree().create_tween()
	t.tween_property(leg.target,"global_position",leg.rest_target.global_position,leg.step_time/2)
	t.tween_property(leg.target,"global_position",target,leg.step_time/2)
	t.tween_callback(func(): stepping = false)

	
func look_for_foothold(leg):
	var space_state = get_world_3d().direct_space_state
	var dir = (leg.placement_target.global_position) + robot.velocity*1*leg.step_time - leg.placement_top.global_position
	var query = PhysicsRayQueryParameters3D.create(leg.placement_top.global_position,leg.placement_top.global_position + 5*dir,0b001)
	var result = space_state.intersect_ray(query)
	if(result):
		return result.position
	else:
		return  null
