extends Node3D

class_name RobotPart

var robot = null

@export var integrity = 30
@export var armor = 30

@export var wear = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	robot = look_for_parent_robot()
	initialize()
	
func initialize():
	pass

func look_for_parent_robot():
	var parent = get_parent().get_parent() #Get the robot that the part is parented to 
	#The first get_parent() is to get to the slot the part is attached to, the second one is to get the actual parent part 
	if(parent is Robot):
		return parent
	else:
		return parent.look_for_parent_robot()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
