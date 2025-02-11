extends "res://Scripts/Parts/RobotPart.gd"

### The CORE is needed for the robot to work

var right_arm = null
var left_arm = null
var movement_module = null

var height = 0.5
	
func attach():
	super()
	if($SlotArmR.get_child_count() > 0):
		right_arm = $SlotArmR.get_child(0)
	if($SlotArmL.get_child_count() > 0):
		left_arm = $SlotArmL.get_child(0)
	if($SlotMovement.get_child_count() > 0):
		movement_module = $SlotMovement.get_child(0)

func _physics_process(delta):
	
	rotation.y = robot.head.rotation.y
	transform.origin.y = height
	rotation.x = 0.2*robot.velocity.dot(robot.head.basis.z)/robot.max_speed
	rotation.z = -0.2*robot.velocity.dot(robot.head.basis.x)/robot.max_speed
	if(movement_module != null):
		transform.origin.y = movement_module.height
	
	if(right_arm != null):
		if(right_arm.hand_tool != null):
			right_arm.target.transform = right_arm.tool_target.transform
		else:
			right_arm.target.global_position = right_arm.rest_target.global_position
	
	
	if(left_arm != null):
		if(left_arm.hand_tool != null):
			left_arm.target.transform = left_arm.tool_target.transform
		else:
			left_arm.target.global_position = left_arm.rest_target.global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
