extends CharacterBody3D

class_name Robot


@export var mass = 120
@export var jump_force = 500
@export var stopping_force = 100000
@export var move_force = 600
@export var air_force = 300
@export var max_speed = 12

var move_direction = Vector2.ZERO
var focus_point = Vector3.ZERO

var height = 1.8;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.z = -move_direction.x*move_force/mass
	velocity.x = move_direction.y*move_force/mass
	if(!is_on_floor()):
		velocity.y += get_gravity().y
	move_and_slide()
	

func action_jump():
	if(is_on_floor()):
		velocity.y = jump_force/mass
