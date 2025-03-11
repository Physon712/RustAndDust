extends Control

@export var robot : Robot
@export var part_display_scene = preload("res://Prefabs/UI/part.tscn")

@onready var status_screen = $StatusScreen

var part_displays = []

func evaluate_robot():
	for d in part_displays:
		d.queue_free()
	part_displays = []
	
	if(robot != null):
		for p in robot.parts:
			var display = part_display_scene.instantiate()
			$StatusScreen.add_child(display)
			display.part = p
			display.initialize()
			part_displays.append(display)
			
