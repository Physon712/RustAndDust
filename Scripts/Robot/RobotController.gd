extends CharacterBody3D

class_name Robot

###Stats
var mass
var energy_production
var energy_consumption

var jump_momentum
var acceleration_force
var air_acceleration_force
var max_speed

var movement_instability

@onready var head = $Head
@onready var collider = $Collider

var parts = []
var weapons = []
var move_direction = Vector3.ZERO

var height = 1.8;
var inaccuracy = 0;

var acceleration
var side_acceleration
var air_acceleration
var side_air_acceleration
var jump_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	attach_parts()


func attach_parts(): #Attach all parts and create the establish the list of the parts
	mass = 1
	energy_production = 0
	energy_consumption = 0
	
	jump_momentum = 0
	acceleration_force = 0
	air_acceleration_force = 0
	max_speed = 0.2
	
	movement_instability = 0
	
	parts = []
	weapons = []
	get_parts(self)
	
	for p in parts:
		p.attach()
		#Add basic properties
		mass += p.mass
		energy_consumption += p.energy_consumption
		#Add optionnal properties and add them to total
		if("energy_production" in p):
			energy_production += p.energy_production
		if("jump_momentum" in p):
			jump_momentum += p.jump_momentum
		if("acceleration_force" in p):
			acceleration_force += p.acceleration_force
		if("air_acceleration_force" in p):
			air_acceleration_force += p.air_acceleration_force
		if("max_speed" in p):
			max_speed += p.max_speed
			
		if("movement_instability" in p):
			movement_instability += p.movement_instability
			
	acceleration = float(acceleration_force)/mass
	air_acceleration = float(air_acceleration_force)/mass
	jump_speed = float(jump_momentum)/mass
	print(parts)
	
	if(acceleration <= 0): ##Always able to move, to avoid softlock of player
		max_speed = 0.2
		acceleration = 3
	
	for p in parts:
		if(p is Weapon):
			weapons.append(p)
	
		
func get_parts(node): ##Get every parts equipped and list them in parts
	for _n in node.get_children():
		get_parts(_n)
		if(_n is RobotPart):
			parts.append(_n)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(height > 0):
		collider.shape.height = height
		collider.position.y = height/2
	var dir = move_direction.normalized()
	var wanted_velocity = dir*max_speed
	
	var dif_velocity = wanted_velocity-velocity
	dif_velocity.y = 0
	var dif_length = dif_velocity.length()
	
	if(is_on_floor()): ##Ground movement
		var adjusting_velocity = Vector3.ZERO
		if(dif_length > 0):
			adjusting_velocity = dif_velocity*(acceleration/dif_length)*delta
		if(adjusting_velocity.length() > dif_length): #Immobilize when close enough to 0
			adjusting_velocity = dif_velocity
		velocity += adjusting_velocity
	else: ##Air movement
		velocity.y += GameData.GRAVITY*delta
		var adjusting_velocity = Vector3.ZERO
		if(dif_length > 0):
			adjusting_velocity = dif_velocity*(air_acceleration/dif_length)*delta
		if(adjusting_velocity.length() > dif_length):
			adjusting_velocity = dif_velocity
		velocity += adjusting_velocity
		
	inaccuracy = (velocity.length()/max_speed) * movement_instability
	move_and_slide()
	
	##Revert to default value and await further instruction
	move_direction = Vector3.ZERO

func action_jump():
	if(is_on_floor()):
		velocity.y = jump_speed
