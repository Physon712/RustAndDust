extends Node3D

class_name RobotPart

var robot = null
var is_attached = false

@export var integrity = 10
@export var max_integrity = 10

@export var wear = 0

@export var mass = 5
@export var energy_consumption = 5

@onready var world = get_tree().get_current_scene()

var slot_parts = []
var freeze = true;
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
	detach_parts()
	robot.attach_parts()


func detach_parts(): ##Detach part and children without updading the attached part of the robot	
	var parent = get_parent()
	var new_transform = global_transform
	parent.remove_child(self)
	world.add_child(self)
	global_transform = new_transform
	is_attached = false
	var part_childs = get_slot_parts(self)
	for child in part_childs:
		child.detach_parts()
	#queue_free()
	##TODO : Activate physics
	activate_physics()

func activate_physics():
	#freeze = false
	queue_free()
	

func look_for_parent_robot():
	var parent = get_parent() #Get the robot that the part is parented to 
	while(!(parent is Robot)):
		parent = parent.get_parent()
	return parent
		
func get_slot_parts(node): ##Get every parts in the slots
	var slot_parts = []
	for _n in node.get_children():
		if(_n is RobotPart): #Found a robot part, add it to the array
			slot_parts.append(_n)
		else: #Look deeper for robot part
			slot_parts.append_array(get_slot_parts(_n))
	return slot_parts

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func bullet_hit(damage):
	take_damage(damage)
	
func take_damage(damage):
	integrity -= damage
	if(integrity <= 0):
		detach()
		
	
