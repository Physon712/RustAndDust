extends "res://Scripts/Parts/RobotPart.gd"

### The CORE is needed for the robot to work

var right_arm = null
var left_arm = null
var movement_module = null

var height = 0.5

var rotation_offset = 0.0
	
func attach():
	super()
	if($SlotArmR.get_child_count() > 0):
		right_arm = $SlotArmR.get_child(0)
	if($SlotArmL.get_child_count() > 0):
		left_arm = $SlotArmL.get_child(0)
	if($SlotMovement.get_child_count() > 0):
		movement_module = $SlotMovement.get_child(0)
		
	if(right_arm != null && left_arm != null): #Handle hand cooperation
		if(right_arm.is_hand_free() && !left_arm.is_hand_free()):
			if(left_arm.hand_tool != null):
				rotation_offset = PI/4
				right_arm.assigned_target = left_arm.hand_tool.off_hand_target
		if(!right_arm.is_hand_free() && left_arm.is_hand_free()):
			if(right_arm.hand_tool != null):
				rotation_offset = -PI/4
				left_arm.assigned_target = right_arm.hand_tool.off_hand_target

func _physics_process(delta):
	
	rotation.y = robot.head.rotation.y + rotation_offset
	transform.origin.y = height
	rotation.x = 0.2*robot.velocity.dot(robot.head.basis.z)/robot.max_speed
	rotation.z = -0.2*robot.velocity.dot(robot.head.basis.x)/robot.max_speed
	if(movement_module != null):
		transform.origin.y = movement_module.height
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
