extends CharacterBody3D

class_name Robot

@export var mass = 90
@export var jump_power = 500
@export var stopping_power = 100000
@export var move_power = 1000
@export var ground_control = 0.1
@export var air_control = 0.01
@export var max_speed = 5#100#12
@export var max_air_speed = 100

@onready var head = $Head

var move_direction = Vector3.ZERO

var height = 1.8;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var move_speed = clamp(move_power/mass,0,max_speed)
	var dir = move_direction.normalized()
	head.transform.origin.y = height
	if(is_on_floor()):
		velocity.z = lerp(velocity.z,dir.z*move_speed,ground_control)
		velocity.x = lerp(velocity.x,dir.x*move_speed,ground_control)
	else:
		#move_speed = clamp(move_power/mass,0,max_air_speed)
		velocity.y += GameData.GRAVITY*delta
		velocity.z = lerp(velocity.z,dir.z*move_speed,air_control)
		velocity.x = lerp(velocity.x,dir.x*move_speed,air_control)
	move_and_slide()
	

func action_jump():
	if(is_on_floor()):
		velocity.y = jump_power/mass
