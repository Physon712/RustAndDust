extends "res://Scripts/Parts/RobotPart.gd"


###STAT
@export var length = 0.8
@export var max_speed = 2
@export var step_time = 0.2
@export var move_power = 5000
@export var jump_power = 250
@export var ground_control = 0.1

###Requirements
@onready var target = $WorldTarget
@onready var local_target = $Target
@onready var rest_target = $RestTarget
@onready var placement_target = $PlacementTarget
@onready var placement_top = $PlacementTop
@export var IK : SkeletonIK3D

func initialize():
	IK.start()

func _physics_process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
