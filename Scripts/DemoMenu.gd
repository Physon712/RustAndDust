extends Node3D

func launch_demo():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_packed(load("res://Levels/Arena/Arena.tscn"))
