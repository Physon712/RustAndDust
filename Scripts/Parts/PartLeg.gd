extends "res://Scripts/Parts/RobotPart.gd"

class_name Leg

###STAT
@export var acceleration_force = 2000
@export var jump_momentum = 250

###ANIMATION
@export var length = 0.8
@export var step_time = 0.2

###Requirements
@onready var target = $WorldTarget
@onready var local_target = $Target
@onready var rest_target = $RestTarget
@onready var placement_target = $PlacementTarget
@onready var placement_top = $PlacementTop
@export var IK : SkeletonIK3D
@export var skeleton_phys : PhysicalBoneSimulator3D

func attach():
	super()	
	if(robot == null):
		return
	IK.start()
	
	

func _process(_delta: float) -> void:
	super(_delta)

func activate_physics():
	if(skeleton_phys != null):
		skeleton_phys.physical_bones_start_simulation.call_deferred()
		skeleton_phys.influence = 1
		IK.stop()
		
		
func get_part_type():
	return GameData.PartType.LEG
