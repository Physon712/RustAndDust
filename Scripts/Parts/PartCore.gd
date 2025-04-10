extends "res://Scripts/Parts/RobotPart.gd"

class_name Core

### The CORE is needed for the robot to work
@export var energy_production = 100

var right_arm = null
var left_arm = null
var movement_module = null
var height = 0.5
var rotation_offset = 0.0

func attach():
	super()
	right_arm = null
	left_arm = null
	movement_module = null
	if($SlotArmR.get_child_count() > 0):
		right_arm = $SlotArmR.get_child(0)
	if($SlotArmL.get_child_count() > 0):
		left_arm = $SlotArmL.get_child(0)
	if($SlotMovement.get_child_count() > 0):
		movement_module = $SlotMovement.get_child(0)
		transform.origin.y = movement_module.height
	#if(right_arm != null && left_arm != null): #Handle hand cooperation
		#if(right_arm.is_hand_free() && !left_arm.is_hand_free()):
			#if(left_arm.hand_tool != null):
				#rotation_offset = PI/4
				#right_arm.assigned_target = left_arm.hand_tool.off_hand_target
		#if(!right_arm.is_hand_free() && left_arm.is_hand_free()):
			#if(right_arm.hand_tool != null):
				#rotation_offset = -PI/4
				#left_arm.assigned_target = right_arm.hand_tool.off_hand_target
var max_tilt = PI/4

func _physics_process(delta):
	if(is_attached):
		rotation.y = robot.head.rotation.y + rotation_offset
		#transform.origin.y = height
		
		if(robot.brain == null): #Down animation
			rotation.x = lerp(rotation.x,PI/2.4,0.1)
			transform.origin.y = lerp(transform.origin.y,0.2,0.1)
		else:
			if(movement_module != null):
				transform.origin.y = lerp(transform.origin.y,max(movement_module.height,0.2),0.1)
			rotation.x = clamp(0.2*robot.velocity.dot(robot.head.basis.z)/robot.max_speed,-max_tilt,max_tilt)
			rotation.z = clamp(-0.2*robot.velocity.dot(robot.head.basis.x)/robot.max_speed,-max_tilt,max_tilt)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	super(_delta)

func get_part_type():
	return GameData.PartType.CORE
