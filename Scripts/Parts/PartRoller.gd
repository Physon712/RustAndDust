extends "res://Scripts/Parts/PartMovement.gd"

class_name Roller

@export var fixed_height:float = 1.2
@export var acceleration_force = 2000
@export var jump_momentum = 250

func _process(_delta: float) -> void:
	super(_delta)

func _physics_process(_delta: float) -> void:
	height = fixed_height
