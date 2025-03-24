extends Control

@export var robot : Robot
@export var part_display_prefab = preload("res://Prefabs/UI/part_display_hud.tscn")

@onready var status_screen = $StatusScreen
@onready var mass_display = $StatusScreen/HBoxContainer/MassLabel

var part_displays = []

func evaluate_robot():
	for d in part_displays:
		d.queue_free()
	part_displays = []
	$StatusScreen/HBoxContainer/MassLabel.text = "Mass : " + str(robot.mass) + " kg"
	if(robot != null && robot.part_core != null):
		evaluate_part($StatusScreen,robot.part_core)
			
func evaluate_part(parent,part): #Create display panel for a single part and its children
	var display = part_display_prefab.instantiate()
	parent.add_child(display)
	display.part = part
	display.initialize()
	part_displays.append(display)
	var children = part.get_slot_parts(part)
	for p in children:
		evaluate_part(display.find_child("Container"),p)
	
	
