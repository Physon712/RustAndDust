extends "res://Scripts/Parts/RobotPart.gd"

###Stats
@export var fire_rate = 0.2;
@export var max_ammo = 32;
@export var recoil_momentum = 500;
@export var bullet_speed = 50;
@export var bullet = preload("res://Prefabs/Projectiles/bullet.tscn");

@onready var world = get_tree().get_current_scene()


var output_transform:Transform3D;
var ammo = max_ammo;
var time_since_last_shot = 0;

func _physics_process(delta):
	if(is_attached):
		output_transform = robot.head.global_transform

func _process(delta):
	if(Input.is_action_pressed("Fire")):
		fire()
	time_since_last_shot += delta;

func fire():
	if(time_since_last_shot > fire_rate):
		if(ammo > 0):
			fire_a_shot()
			ammo -= 1
			time_since_last_shot = 0
	
func fire_a_shot():
	print("bang!")
	var b = bullet.instantiate()
	world.add_child(b)
	b.transform = output_transform
	b.velocity = -output_transform.basis.z*bullet_speed
	
	
