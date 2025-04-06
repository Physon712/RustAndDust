extends "res://Scripts/Parts/PartMovement.gd"

class_name Roller

@export var fixed_height = 1
@export var acceleration_force = 2000
@export var jump_momentum = 250


func _physics_process(delta: float) -> void:
	height = fixed_height
