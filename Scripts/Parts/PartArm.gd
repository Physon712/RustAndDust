extends "res://Scripts/Parts/RobotPart.gd"

class_name ArmHand

var hand_tool = null
###Stats
@export var inaccuracy = 0.02
@export var strength = 5

@export var recoil_control = 0.2

@onready var target = $Target
@onready var rest_target = $RestTarget
@onready var tool_target = $ToolTarget
@onready var tool_slot = $ToolTarget/SlotHandTool

@onready var assigned_target = rest_target

@export var IK : SkeletonIK3D

var is_flipped = false

func attach():
	super()
	IK.start()
	if(tool_slot.get_child_count() > 0):
		hand_tool = tool_slot.get_child(0)
		assigned_target = hand_tool.main_hand_target
		hand_tool.inaccuracy = inaccuracy
	if(get_parent().scale.x < 0):
		is_flipped = true
	
func is_hand_free():
	return (hand_tool == null)
	
func _physics_process(delta: float) -> void:
	if(!is_attached): #If part is detached from robot
		pass
		
	target.global_position = assigned_target.global_position
		
	###Handle gun rotation and recoil
	tool_target.global_rotation = robot.head.global_rotation
	if(is_flipped):
		tool_target.global_rotation.x = -robot.head.global_rotation.x
	tool_slot.rotation.x = lerp(tool_slot.rotation.x,0.0,recoil_control)
	tool_slot.rotation.y = lerp(tool_slot.rotation.y,0.0,recoil_control)
	tool_slot.position = lerp(tool_slot.position,Vector3.ZERO,recoil_control)
	
