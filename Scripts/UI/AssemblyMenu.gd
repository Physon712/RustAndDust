extends Control

@onready var robot_a_display = $VBoxContainer/HSplitContainer/ScrollContainer2/RobotA
@onready var robot_b_display = $VBoxContainer/HSplitContainer/ScrollContainer3/RobotB
@onready var inventory_display = $VBoxContainer/HSplitContainer/ScrollContainer/Inventory

@export var robot_a : Robot  = null
@export var inventory : Inventory = null
@export var robot_b : Robot = null

@export var attach_sound_clip = preload("res://Audio/Sounds/ar_mag_insert.wav")
@export var detach_sound_clip = preload("res://Audio/Sounds/ar_mag_eject.wav")
@export var audio_player : AudioStreamPlayer
var mouse_data = {
	pressed = false, #Is the mouse loaded with data ? Has something being pressed ?
	from_inventory = false, #Is it coming from a display from the inventory
	associated_id = 0,
	associated_part = null, 
	last_selected = null # The last selected display of a part, inventory or otherwise
}

func play_detach_sound():
	audio_player.stream = detach_sound_clip
	audio_player.playing = true
	
func play_attach_sound():
	audio_player.stream = attach_sound_clip
	audio_player.playing = true

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
	mouse_data.selected = null 

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
		
var can_close = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_released("Inventory") || Input.is_action_just_released("Use")):
		can_close = true
	if(can_close && (Input.is_action_just_pressed("Inventory")||Input.is_action_just_pressed("Use"))):
		GameData.exit_menu_mode()
		queue_free()
