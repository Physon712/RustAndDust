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
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed: #Inventory to mouse data unless already holding mouse data
		if(assembly_menu != null && !assembly_menu.mouse_data.pressed):
			assembly_menu.mouse_data.pressed = true
			assembly_menu.mouse_data.from_inventory = true
			assembly_menu.mouse_data.associated_id = associated_id
			assembly_menu.mouse_data.associated_part = null
