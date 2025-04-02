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
@onready var main_slot  = $Parts
@onready var nav = $NavAgent

var parts = []
var part_core = null
var camera = null
var brain = null
var weapons = []

@onready var move_direction = Vector3.ZERO

var height = 1.8;
var inaccuracy = 0;

var acceleration
var side_acceleration
var air_acceleration
var side_air_acceleration
var jump_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Robot")
	attach_parts()


func attach_parts(): #Attach all parts and create the establish the list of the parts
	mass = 0
	energy_production = 0
	energy_consumption = 0
	
	jump_momentum = 0
	acceleration_force = 0
	air_acceleration_force = 0
	max_speed = 0.2
	
	movement_instability = 0
	
	parts = []
	weapons = []
	part_core = null
	brain = null
	get_parts(self)
	
	if($Parts.get_child_count() > 0): # Register for the main part, the core
		part_core = $Parts.get_child(0)
	else:
		pass
		#queue_free()
	
	for p in parts: ## Account for every stat of every part attached
		p.attach()
		#Add basic properties
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
	
	if(acceleration <= 0): ##Always able to move, to avoid softlock of player
		max_speed = 0.6
		acceleration = 2
	
	#Establish list of all weapons
	for p in parts:
		if(p is Weapon):
			weapons.append(p)
			
	if(camera != null):
		camera.current = false
	
		
func get_parts(node): ##Get every parts equipped and list them in parts
	for _n in node.get_children():
		get_parts(_n)
		if(_n is RobotPart):
			mass += _n.mass
			parts.append(_n)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(height > 0):
		collider.shape.height = height
		collider.position.y = height/2
	else:
		collider.disabled = true
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
	
	if(!collider.disabled):
		move_and_slide()
	
	##Revert to default value and await further instruction
	move_direction = Vector3.ZERO

func action_jump(): # Try to jump
	if(is_on_floor()):
		velocity.y = jump_speed

func explosion(force,ray,pos,_reponsible : Robot = null): #Apply force for an explosion
	var d = (global_transform.origin-pos)
	if d.length() <= ray:
		var appliedforce = ((1-d.length()/ray)**2)*force #Square
		d = d.normalized()
		apply_central_impulse(d*(appliedforce))
		
func directional_explosion(force,ray,pos,direction,_responsible : Robot = null): #Apply force for a directionnal push
	var d = (global_transform.origin-pos)
	if d.length() <= ray:
		var appliedforce = ((1-d.length()/ray)**2)*force #Square
		apply_central_impulse(direction*(appliedforce))
		
func apply_central_impulse(energie): # Same as function for a rigidbody of the same name
	var speed = energie/mass
	velocity += speed

func take_damage(damage,_responsible : Robot = null):
	if(brain != null):
		brain.sense_damage(damage,_responsible)
