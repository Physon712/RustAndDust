extends "res://Scripts/Parts/Weapon.gd"

class_name Gun

###Stats
@export var fire_rate = 0.1;
@export var max_ammo = 320;
@export var dispersion = 0.01 #Degrees
@export var bullet_count = 1;
@export var bullet_speed = 150;
@export var bullet = preload("res://Prefabs/Projectiles/bullet.tscn");
@export var animator : AnimationPlayer;
@export var firesound : AudioStreamPlayer3D;
@export var fireparticle : GPUParticles3D;
@export var muzzle : Marker3D;

var output_transform:Transform3D;
var ammo = max_ammo;
var time_since_last_shot = 0;

func attach():
	super()

func _physics_process(delta):
	if(is_attached):
		output_transform = robot.head.global_transform

func _process(delta):
	time_since_last_shot += delta;

func use(): #Use the weapon = fire the weapon
	fire()

func fire(): #Try to fire the weapon, check for ammo and fire rate
	if(time_since_last_shot > fire_rate):
		if(ammo > 0):
			fire_a_shot()
			ammo -= 1
			time_since_last_shot = 0
			if(animator != null):
				animator.play("Fire")
			if(firesound != null):
				firesound.play(0.0)
			if(fireparticle != null):
				fireparticle.emitting = true
	
func fire_a_shot(): #Fire the weapon, instantiate a bullet and apply it speed in the aim direction of the robot head
	var dir = -robot.head.basis.z
	var deviation = deg_to_rad(inaccuracy+robot.inaccuracy)
	dir = dir.rotated(robot.head.basis.y,randf_range(-deviation,deviation) + rotation.y)
	dir = dir.rotated(robot.head.basis.x,randf_range(-deviation,deviation) + rotation.x)
	for i in range(bullet_count):
		var b = bullet.instantiate()
		world.add_child(b)
		var dispersion = deg_to_rad(dispersion)
		dir = dir.rotated(robot.head.basis.y,randf_range(-dispersion,dispersion) + rotation.y)
		dir = dir.rotated(robot.head.basis.x,randf_range(-dispersion,dispersion) + rotation.x)
		b.transform = robot.head.global_transform
		b.velocity = dir*bullet_speed

func evaluate_total_inaccuracy():
	return super() + dispersion
