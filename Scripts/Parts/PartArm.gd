extends "res://Scripts/Parts/RobotPart.gd"

var hand_tool = null

@export var length = 0.8
@export var max_speed = 2
@export var step_time = 0.3
@export var recoil_control = 0.2

@onready var target = $Target
@onready var rest_target = $RestTarget
@onready var tool_target = $SlotHandTool
@onready var tool_rest_target = $RestTargetHandTool

@export var IK : SkeletonIK3D

var is_flipped = false

func attach():
	super()
	IK.start()
	if($SlotHandTool.get_child_count() > 0):
		hand_tool = $SlotHandTool.get_child(0)
	if(get_parent().scale.x < 0):
		is_flipped = true
	
func _physics_process(delta: float) -> void:
	if(!is_attached):
		pass
	tool_target.global_rotation = robot.head.global_rotation
	if(is_flipped):
		tool_target.global_rotation.x = -robot.head.global_rotation.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
