extends Node3D

class_name RobotPart

var robot = null
var is_attached = false

@export var front_name = "Robot Part"

@export var paint_color : Color = Color.YELLOW
@export var paint_material : ShaderMaterial = preload("res://Textures/Materials/base_wearmat.tres").duplicate()

@export var integrity = 10
@export var max_integrity = 10

@export var wear = 0

@export var mass = 5
@export var energy_consumption = 5

@onready var world = get_tree().get_current_scene()
var paint_job;
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
		activate_physics()
	paint_material.set_shader_parameter("mainColor",paint_color)
	paint_material.set_shader_parameter("wear",1-(float(integrity)/max_integrity))

func detach():
	if(is_attached && robot != null):
		var old_robot = robot
		detach_parts()
		old_robot.attach_parts()


func detach_parts(): ##Detach part and children without updading the attached part of the robot	
	var parent = get_parent()
	var new_transform = global_transform
	parent.remove_child(self)
	world.add_child(self)
	global_transform = new_transform
	is_attached = false
	robot = null
	var part_childs = get_slot_parts(self)
	for child in part_childs:
		child.detach_parts()
	#queue_free()
	##TODO : Activate physics
	activate_physics()
	
func paint_meshes():
	var meshes = []
	
	

func activate_physics():
	#freeze = false
	var children = get_children()
	for c in children:
		if(c is RigidBody3D):
			c.freeze = false
			c.mass = mass

func look_for_parent_robot():
	var parent = get_parent() #Get the robot that the part is parented to 
	if(parent != null):
		while(!(parent is Robot) && parent != null):
				parent = parent.get_parent()
	return parent
		
func get_slot_parts(node): ##Get every parts in the slots of the node
	var slot_parts = []
	for _n in node.get_children():
		if(_n is RobotPart): #Found a robot part, add it to the array
			slot_parts.append(_n)
		else: #Look deeper for robot part
			slot_parts.append_array(get_slot_parts(_n))
	return slot_parts
	
func get_slots(node): ##Get every slots of the node
	var slots = []
	for _n in node.get_children():
		if(_n is Slot): #Found a robot part, add it to the array
			slots.append(_n)
		else: #Look deeper for robot part
			slots.append_array(get_slots(_n))
	return slots

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func bullet_hit(damage):
	take_damage(damage)
	
func take_damage(damage):
	integrity -= damage
	paint_material.set_shader_parameter("wear",1-(float(integrity)/max_integrity))
	if(integrity <= 0):
		detach()
		
func get_part_type():
	return GameData.DataType.CORE
	
