extends "res://Scripts/Parts/PartBrain.gd"

@export var target : Robot
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta):
	if(robot.weapons.size() > 0):
		robot.weapons[0].use()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	robot.move_direction = target.global_position-robot.global_position
	robot.head.look_at(target.head.global_position)
