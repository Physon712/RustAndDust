extends Node3D

class_name RobotPart

var robot = null
var is_attached = false

@export var integrity = 30
@export var wear = 0

@export var mass = 5
@export var energy_consumption = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attach()
	
func attach():
	robot = look_for_parent_robot()
	if(robot != null):
		is_attached = true
	else:
		is_attached = false

func detach():
	is_attached = false

func look_for_parent_robot():
	var parent = get_parent() #Get the robot that the part is parented to 
	while(!(parent is Robot)):
		parent = parent.get_parent()
	return parent
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
