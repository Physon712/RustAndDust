extends Node3D

@export var speed = 50
@export var damage = 18

var shooter : Robot;

@onready var velocity = -basis.z*speed
var next_position = Vector3.ZERO
@export var lifetime = 20.0
@export var spark_prefab = preload("res://Prefabs/Projectiles/barrel_explosion.tscn")
@onready var world = get_tree().get_current_scene() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	lifetime -= delta
	if(lifetime <= 0):
		queue_free()
	next_position = global_position + velocity * delta
	velocity += Vector3.UP * GameData.GRAVITY * delta
	check_for_collision()
	global_position = next_position
		
func check_for_collision(): #Raycast between current position and next position, and collide
	#Raycast from current position to futur position
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position,next_position,0b101)
	var result = space_state.intersect_ray(query)
	if(result):
		##Create explosion
		var explosion = spark_prefab.instantiate()
		world.add_child(explosion)
		explosion.transform.origin = result.position - basis.z*0.1
		explosion.transform = explosion.transform.looking_at(-basis.z+explosion.transform.origin,Vector3.UP)
		if(result.collider.has_method("bullet_hit")):
				result.collider.call("bullet_hit",damage,shooter)
		queue_free()
