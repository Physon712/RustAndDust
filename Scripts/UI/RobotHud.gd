extends Control

@export var robot : Robot
@export var part_display_prefab = preload("res://Prefabs/UI/part_display_hud.tscn")
@export var weapon_display_prefab = preload("res://Prefabs/UI/weapon_display_hud.tscn")

@onready var status_screen = $StatusScreen
@onready var weapon_screen = $WeaponScreen
@onready var mass_display = $StatusScreen/HBoxContainer/MassLabel
@onready var reticle = $Reticule
@onready var use_hint = $UseHint

var part_displays = []
var weapon_displays = []

func evaluate_robot():
	for d in part_displays:
		d.queue_free()
	for w in weapon_displays:
		w.queue_free()
	part_displays = []
	weapon_displays = []
	$StatusScreen/HBoxContainer/MassLabel.text = "Mass : " + str(robot.mass) + " kg"
	if(robot != null && robot.part_core != null):
		evaluate_part($StatusScreen,robot.part_core)

	robot.establish_weapon_list()
	for w in range(robot.weapons.size()):
		evaluate_weapon($WeaponScreen,w)
	
		
func evaluate_weapon(parent,weapon_id):  #Create display panel for a weapon
	var display = weapon_display_prefab.instantiate()
	parent.add_child(display)
	display.robot = robot
	display.weapon_id = weapon_id
	display.initialize()
	weapon_displays.append(display)

func evaluate_part(parent,part): #Create display panel for a single part and its children
	var display = part_display_prefab.instantiate()
	parent.add_child(display)
	display.part = part
	display.initialize()
	part_displays.append(display)
	var children = part.get_slot_parts(part)
	for p in children:
		evaluate_part(display.find_child("Container"),p)
		
func _physics_process(_delta):
	var max_inaccuracy = 0
	for w in robot.weapons: ##Evaluate maximum inaccuracy for the reticle size
		var inaccuracy = w.evaluate_total_inaccuracy()
		if inaccuracy > max_inaccuracy:
			max_inaccuracy = inaccuracy
	var new_size = Vector2.ONE * float(max_inaccuracy)/75 * size.x + Vector2.ONE * 10
	reticle.set_size(new_size,true)
	reticle.set_position(Vector2(size.x,size.y)/2-new_size/2)
	#reticle.offset_left = -new_size.x/2
	#reticle.offset_right = new_size.x/2
	#reticle.offset_top = -new_size.y/2
	#reticle.offset_bottom = new_size.y/2
	
	
	
