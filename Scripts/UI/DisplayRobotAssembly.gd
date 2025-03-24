extends VBoxContainer

@export var robot : Robot
@export var part_display_prefab = preload("res://Prefabs/UI/part_display_assembly.tscn")
@export var part_display_empty_prefab = preload("res://Prefabs/UI/part_display_assembly_empty.tscn")
@export var assembly_menu = null

@onready var mass_display = $HBoxContainer/MassLabel

var slot_displays = []

func evaluate_robot():
	for d in slot_displays:
		d.queue_free()
	slot_displays = []
	$HBoxContainer/MassLabel.text = "Mass : " + str(robot.mass) + " kg"
	$HBoxContainer/MassLabel.visible = false
	if(robot != null):
		evaluate_slot(self,robot.main_slot)
			
		
func evaluate_slot(parent,slot): #Create display panel for a single slot and its children
	var display = part_display_prefab.instantiate()
	parent.add_child(display)
	display.slot = slot
	display.assembly_menu = assembly_menu
	display.initialize()
	slot_displays.append(display)
	var part = null
	if(slot.get_child_count() > 0): #Check if the slot contain a part
		part = slot.get_child(0)
	if(part != null): #If there is then check slots of part
		var children = part.get_slots(slot)
		for p in children:
			evaluate_slot(display.find_child("Container"),p)
	
	
