extends MarginContainer

@onready var integrity_bar = $Container/Status/Integrity
@onready var name_display = $Container/Status/Label 

@export var associated_inventory : Inventory = null
@export var associated_id = 0
@export var assembly_menu = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#When selected, show it... somehow
	if(assembly_menu != null && assembly_menu.mouse_data.pressed && assembly_menu.mouse_data.last_selected == self):
		modulate = Color.LAWN_GREEN
	else:
		modulate = Color.WHITE


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT: #Inventory to mouse data unless already holding mouse data
		if(assembly_menu != null):
			assembly_menu.clear_mouse_data()
			if(!assembly_menu.mouse_data.pressed):## DRAG
				assembly_menu.mouse_data.last_selected = self
				assembly_menu.mouse_data.pressed = true
				assembly_menu.mouse_data.from_inventory = true
				assembly_menu.mouse_data.associated_id = associated_id
				assembly_menu.mouse_data.associated_part = null
				
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if(assembly_menu != null):
			var loot = assembly_menu.inventory.instantiate_part(get_tree().get_current_scene(),associated_id)
			loot.transform.origin = assembly_menu.robot_a.head.global_position - assembly_menu.robot_a.head.basis.z
			loot.attach()
			assembly_menu.inventory.remove_part(associated_id)
			assembly_menu.play_detach_sound()
			assembly_menu.refresh()
