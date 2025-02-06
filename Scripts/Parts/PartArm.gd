extends "res://Scripts/Parts/RobotPart.gd"

@export var length = 0.8
@export var max_speed = 2
@export var step_time = 0.3
@onready var target = $WorldTarget
@onready var local_target = $Target
@onready var rest_target = $RestTarget
@onready var tool_target = $SlotHandTool

@export var IK : SkeletonIK3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	IK.start()


func _physics_process(delta: float) -> void:
	rotation.x = robot.head.rotation.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
