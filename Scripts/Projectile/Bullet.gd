extends Node3D

@export var speed = 250
@export var damage = 5

@onready var velocity = -basis.z*speed
var next_position = Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	next_position = global_position+velocity * delta
	velocity += Vector3.UP*GameData.GRAVITY*delta
	check_for_collision()
	global_position = next_position
		
func check_for_collision():
	#Raycast from current position to futur position
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position,next_position,0b101)
	var result = space_state.intersect_ray(query)
	if(result):
		print(result.collider.name)
		if(result.collider.has_method("bullet_hit")):
				result.collider.call("bullet_hit",damage)
