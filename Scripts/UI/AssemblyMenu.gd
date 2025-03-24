extends Control

@onready var robot_a_display = $HSplitContainer/ScrollContainer2/RobotA
@onready var robot_b_display = $HSplitContainer/ScrollContainer3/RobotB
@onready var inventory_display = $HSplitContainer/ScrollContainer/Inventory

@export var robot_a : Robot  = null
@export var inventory : Inventory = null
@export var robot_b : Robot = null

var mouse_data = {
	pressed = false,
	from_inventory = false,
	associated_id = 0,
	associated_part = null
	
}

func initialize():
	inventory_display.inv = inventory
	inventory_display.assembly_menu = self
	robot_a_display.robot = robot_a
	robot_b_display.robot = robot_b
	refresh()
	
func clear_mouse_data():
	mouse_data.pressed = false
	mouse_data.from_inventory = false
	mouse_data.associated_id = 0
	mouse_data.associated_part = null

func refresh():
	inventory_display.refresh_display_list()
	if(robot_a != null):
		robot_a_display.visible = true
		robot_a_display.assembly_menu = self
		robot_a_display.evaluate_robot()
	if(robot_b != null):
		robot_b_display.visible = true
		robot_b_display.assembly_menu = self
		robot_b_display.evaluate_robot()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(GameData.in_menu && Input.is_action_just_pressed("Inventory")):
		GameData.exit_menu_mode()
		queue_free()
