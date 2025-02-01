extends Node

@export var target : Robot
@onready var robot = get_parent() # Get the robot the player controls
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	robot.move_direction = target.global_position-robot.global_position
	
	robot.head.look_at(target.head.global_position)
