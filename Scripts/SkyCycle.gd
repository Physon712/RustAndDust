extends Node3D

@onready var animator = $DayAndNightCycle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.play_section("SimpleDayAndNightCycle",0.75,-1,-1,1/600)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
