extends Node3D

class_name RobotPart

var robot = null
var is_attached = false

@export var front_name = "Robot Part"

@export var paint_color : Color = Color.YELLOW
@export var paint_material : ShaderMaterial = preload("res://Textures/Materials/base_wearmat.tres").duplicate()
@export var light_material : StandardMaterial3D  = preload("res://Textures/Materials/base_light.tres").duplicate()
@export var explosion_prefab = preload("res://Prefabs/FX/part_explosion.tscn")

##Stats
@export var max_integrity = 10
@export var wear = 0
@export var mass = 5
@export var energy_consumption = 5

@onready var world = get_tree().get_current_scene()
var paint_job;
var freeze = true;
var lifetime = 30.0;
var integrity = 10
var has_exploded = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#integrity = round(max_integrity*(0.2+0.8*randf()))
	integrity = max_integrity
	attach()
	
func _process(delta):
	if(integrity <= 0):
		lifetime -= delta
		if(lifetime <= 0): #Automaticly cleanup broken part
			queue_free()
	
func attach(): #Base procedure for attaching part to a robot
	#Try to attach the part to a robot if possible, otherwiser just fall down to ground
	robot = look_for_parent_robot()
	if(robot != null):
		is_attached = true
		position = Vector3.ZERO
	else:
		is_attached = false
		activate_physics()
	paint_material.set_shader_parameter("mainColor",paint_color)
	paint_material.set_shader_parameter("wear",1-(float(integrity)/max_integrity))
	if(robot != null && robot.brain != null):
		light_material.albedo_color = robot.brain.ai_color
		light_material.emission = robot.brain.ai_color
	else:
		light_material.albedo_color = Color.BLACK
		light_material.emission = Color.BLACK
	
	
func detach(): #Detach the part and its childs parts
	#Fall down to the ground afterward
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
	activate_physics()
	light_material.albedo_color = Color.BLACK
	light_material.emission = Color.BLACK
	
func activate_physics():
	#freeze = false
	var children = get_children()
	for c in children:
		if(c is RigidBody3D):
			c.freeze = false
			c.mass = mass

func look_for_parent_robot(): #Get the robot that the part is parented to 
	var parent = get_parent()
	if(parent != null):
		while(!(parent is Robot) && parent != null):
				parent = parent.get_parent()
	return parent
		
func get_slot_parts(node): ##Get every parts in the slots of the node given as argument
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
		if(_n is Slot): #Found a slot, add it to the array
			slots.append(_n)
		else: #Look deeper for slots
			slots.append_array(get_slots(_n))
	return slots

func bullet_hit(damage,_responsible : Robot = null):
	take_damage(damage,_responsible)
		
	
func take_damage(damage,_responsible : Robot = null):
	integrity -= damage
	if(robot != null):
		robot.take_damage(damage,_responsible)
	paint_material.set_shader_parameter("wear",1-(float(integrity)/max_integrity))
	if(integrity <= 0):
		detach()
		#Explode
		if(!has_exploded):
			var e = explosion_prefab.instantiate()
			world.add_child(e)
			e.global_position = global_position
			has_exploded = true
		
func get_part_type():
	return GameData.DataType.CORE
	
