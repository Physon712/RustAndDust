extends Node3D

@onready var player_brain_prefab = load("res://Prefabs/Brains/player_brain.tscn")
@export var speed : float = 6.0	
@export var speed_mult : float = 1.0
@onready var use_hint = $Control/UseHint

var dir = Vector3.ZERO

func _process(_delta):
	dir = Vector3.ZERO
	
	if(Input.is_action_pressed("Zoom")):
		speed_mult = 4.0
	else:
		speed_mult = 1.0
	
	# Up or down
	if(Input.is_action_pressed("Jump")):
		dir += basis.y
	if(Input.is_action_pressed("Fire3")):
		dir -= basis.y
		
	# Directionnal Input
	if(Input.is_action_pressed("Forward")):
		dir -= basis.z
	if(Input.is_action_pressed("Backward")):
		dir += basis.z
	if(Input.is_action_pressed("Right")):
		dir += basis.x
	if(Input.is_action_pressed("Left")):
		dir -= basis.x
	
	global_position += dir*_delta*speed*speed_mult
	
func _physics_process(_delta):
	#Interaction raycast
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position,position-5*basis.z,0b010)
	var result = space_state.intersect_ray(query)
	if(result && result.collider is Robot && result.collider.brain != null):
		use_hint.text = "Take Control"
		if(Input.is_action_just_pressed("Use")):
			take_control(result.collider)
	else:
		use_hint.text = ""
	

func _input(event):  #Mouse input
	if event is InputEventMouseMotion:
		rotation.y += -GameData.mouse_sensivity*event.relative.x
		rotation.x += -GameData.mouse_sensivity*event.relative.y
		rotation.x = clamp(rotation.x,-1.5,1.5)
		
func take_control(robot : Robot): #Replace the current brain with the one from the player
	var parent = robot.brain.get_parent()
	var new_brain = player_brain_prefab.instantiate()
	var old_brain = robot.brain
	old_brain.detach()
	old_brain.queue_free()
	parent.add_child(new_brain)
	new_brain.attach()
	robot.attach_parts()
	queue_free()
