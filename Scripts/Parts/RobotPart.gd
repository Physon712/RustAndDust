extends Node3D

class_name RobotPart

var robot = null
var is_attached = false

@export var integrity = 10
@export var wear = 0

@export var mass = 5
@export var energy_consumption = 5

@onready var world = get_tree().get_current_scene()

var slot_parts = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attach()
	
func attach():
	robot = look_for_parent_robot()
	if(robot != null):
		is_attached = true
		position = Vector3.ZERO
	else:
		is_attached = false

func detach():
	#queue_free()
	get_parent().remove_child(self)
	world.add_child(self)
	is_attached = false
	queue_free()
	##TODO : Activate physics
	robot.attach_parts()
	

func look_for_parent_robot():
	var parent = get_parent() #Get the robot that the part is parented to 
	while(!(parent is Robot)):
		parent = parent.get_parent()
	return parent
		
func get_slot_parts(node): ##Get every parts in the slots
	for _n in node.get_children():
		if(_n is RobotPart):
			slot_parts.append(_n)
		else:
			get_slot_parts(_n)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func bullet_hit(damage):
	take_damage(damage)
	
func take_damage(damage):
	integrity -= damage
	print(integrity)
	if(integrity <= 0):
		detach()
		
	
