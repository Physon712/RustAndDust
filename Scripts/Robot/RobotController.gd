extends CharacterBody3D

class_name Robot

@export var mass = 180

@export var jump_momentum = 500

@export var acceleration_force = 1200
#@export var side_acceleration_force = 1200
@export var air_acceleration_force = 420
#@export var side_air_acceleration_force = 420

@export var max_speed = 5#100#12

@onready var head = $Head

var move_direction = Vector3.ZERO

var height = 1.8;

var acceleration = float(acceleration_force)/mass
#var side_acceleration = side_acceleration_force/mass
var air_acceleration = float(air_acceleration_force)/mass
#var side_air_acceleration = side_air_acceleration_force/mass
var jump_speed = float(jump_momentum)/mass
# Called when the node enters the scene tree for the first time.
func _ready():
	attach_parts()

func attach_parts():
	acceleration = float(acceleration_force)/mass
	air_acceleration = float(air_acceleration_force)/mass
	jump_speed = float(jump_momentum)/mass

func _process(delta):
	print(1/delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	head.transform.origin.y = height
	
	var dir = move_direction.normalized()
	var wanted_velocity = dir*max_speed
	
	var dif_velocity = wanted_velocity-velocity
	dif_velocity.y = 0
	var dif_length = dif_velocity.length()
	if(is_on_floor()):
		var adjusting_velocity = Vector3.ZERO
		if(dif_length > 0):
			adjusting_velocity = dif_velocity*(acceleration/dif_length)*delta
		if(adjusting_velocity.length() > dif_length):
			adjusting_velocity = dif_velocity
		velocity += adjusting_velocity
	else:
		velocity.y += GameData.GRAVITY*delta
		var adjusting_velocity = Vector3.ZERO
		if(dif_length > 0):
			adjusting_velocity = dif_velocity*(air_acceleration/dif_length)*delta
		if(adjusting_velocity.length() > dif_length):
			adjusting_velocity = dif_velocity
		print(adjusting_velocity)
		velocity += adjusting_velocity
	move_and_slide()
	

func action_jump():
	if(is_on_floor()):
		velocity.y = jump_speed
