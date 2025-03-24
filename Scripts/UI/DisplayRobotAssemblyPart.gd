extends Container

@export var robot : Robot
@export var slot : Slot
@export var associated_part : RobotPart = null
@export var assembly_menu = null

@onready var integrity_bar = $Container/Status/Integrity
@onready var name_display = $Container/Status/Label 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initialize():
	if(slot.get_child_count() > 0):
		associated_part = slot.get_child(0)
		$Container/Status/Label.text = slot.front_name + "[" + associated_part.front_name + "]"
		$Container/Status/Integrity.max_value = associated_part.max_integrity
		$Container/Status/Integrity.visible = true
	else:
		$Container/Status/Label.text = slot.front_name + "[EMPTY]"
		$Container/Status/Integrity.visible = false
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(associated_part != null):
		integrity_bar.value = associated_part.integrity
		if(!associated_part.is_attached):
			queue_free()
	else:
		integrity_bar.value = 0

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed: #Part from assembly menu to mouse data
		if(assembly_menu != null && associated_part != null):
			print(associated_part.front_name)
			assembly_menu.mouse_data.pressed = true
			assembly_menu.mouse_data.from_inventory = false
			assembly_menu.mouse_data.associated_id = 0
			assembly_menu.mouse_data.associated_part = associated_part
			
