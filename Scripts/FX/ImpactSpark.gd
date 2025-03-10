extends Node3D

@export var part : GPUParticles3D
@export var sound : AudioStreamPlayer3D

var has_sparked = false
var lifetime = 1;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	lifetime -= _delta
	if !has_sparked :
		part.emitting = true
		for p in part.get_children():
			p.emitting = true
		sound.playing = true
		has_sparked = true
	if(lifetime <= 0):
		queue_free()
