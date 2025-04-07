extends Node3D

@export var damage = 200
@export var force = 200
@export var forwardforce = 0
@export var radius = 10.0

@export var lifetime = 2
var has_exploded = false

@onready var flash = $Flash

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !has_exploded:
		$Particles.emitting = true
		for part in $Particles.get_children():
			part.emitting = true
		get_tree().call_group("Robot","explosion",damage,force*20,radius*5,transform.origin)
		get_tree().call_group("PhysObj","explosion",damage,force,radius,transform.origin)
		has_exploded = true
		
	lifetime -= delta
	if lifetime <= 1.8 && flash!= null:
		flash.visible = false
	if lifetime <= 0 :
		queue_free()
