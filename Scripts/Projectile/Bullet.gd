extends Node3D

@export var speed = 250
@export var damage = 5

var shooter : Robot;

@onready var velocity = -basis.z*speed
var next_position = Vector3.ZERO

@export var lifetime = 5.0
@export var spark_prefab = preload("res://Prefabs/FX/bullet_impact_spark.tscn")
@export var spark_prefab_env = preload("res://Prefabs/FX/bullet_impact.tscn")


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
		if(result.collider.has_method("bullet_hit")):
			result.collider.call("bullet_hit",damage,shooter)
			##Create impact spark effect
			var explosion = spark_prefab.instantiate()
			world.add_child(explosion)
			explosion.transform.origin = result.position - basis.z*0.1
			explosion.transform = explosion.transform.looking_at(-basis.z+explosion.transform.origin,Vector3.UP)
		else:
			##Create impact spark effect for the environment
			var explosion = spark_prefab_env.instantiate()
			world.add_child(explosion)
			explosion.transform.origin = result.position - basis.z*0.1
			explosion.transform = explosion.transform.looking_at(-basis.z+explosion.transform.origin,Vector3.UP)
		queue_free()
