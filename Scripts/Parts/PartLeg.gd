extends "res://Scripts/Parts/RobotPart.gd"

class_name Leg

###STAT
@export var acceleration_force = 2000
@export var max_speed = 2
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

func attach():
	super()
	IK.start()

func _physics_process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
