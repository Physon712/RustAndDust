extends Node3D

@onready var animator = $DayAndNightCycle
@export var time_scale = 0.0
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.play("SimpleDayAndNightCycle",-1,time_scale/600)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
