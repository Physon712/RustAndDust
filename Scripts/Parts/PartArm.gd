extends "res://Scripts/Parts/RobotPart.gd"

class_name ArmHand

var hand_tool = null
###Stats
@export var inaccuracy = 1 #In degrees
@export var strength = 3

@onready var target : Marker3D = $Target
@onready var rest_target = $RestTarget
@onready var tool_target = $ToolTarget
@onready var tool_slot = $ToolTarget/SlotHandTool

@onready var assigned_target = rest_target

@export var IK : SkeletonIK3D
@export var skeleton : PhysicalBoneSimulator3D

var is_flipped = false

func attach():
	super()
	assigned_target = rest_target
	IK.start()
	if(tool_slot.get_child_count() > 0):
		hand_tool = tool_slot.get_child(0)
		assigned_target = hand_tool.main_hand_target
		hand_tool.inaccuracy = inaccuracy
		hand_tool.grip_strength = strength
	if(get_parent().scale.x < 0):
		is_flipped = true
		#tool_target.scale.x = -1
		#tool_target.scale.y = -1
		#tool_target.scale.z = -1
	
func is_hand_free():
	return (hand_tool == null)
	
func _physics_process(delta: float) -> void:
	if(!is_attached): #If part is detached from robot
		pass
		
	target.global_position = assigned_target.global_position
	target.global_rotation = assigned_target.global_rotation
		
	###Handle gun rotation and recoil
	tool_target.global_rotation = robot.head.global_rotation
	if(is_flipped):
		target.rotate_object_local(Vector3.LEFT,PI)
		tool_target.global_rotation.x = -robot.head.global_rotation.x
	
func activate_physics():
	if(skeleton != null):
		IK.active = false
		IK.influence = 0
		skeleton.physical_bones_start_simulation()
		skeleton.influence = 1
		print("ezf")
