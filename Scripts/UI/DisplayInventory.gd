extends VBoxContainer

@export var inv : Inventory = null
@export var part_display_prefab = preload("res://Prefabs/UI/part_display_inventory.tscn")
@export var assembly_menu = null

var displays = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func refresh_display_list():
	erase_display_list()
	
	var sorted_inv = []
	for p in inv.inv:
		sorted_inv.append(inv.inv[p])
	sorted_inv.sort_custom(sort_inv)
	
	var inv_size = sorted_inv.size()
	for p in range(inv_size):
		var display = part_display_prefab.instantiate()
		add_child(display)
		display.name_display.text = sorted_inv[p].name
		display.integrity_bar.value = sorted_inv[p].integrity
		display.integrity_bar.max_value = sorted_inv[p].max_integrity
		display.associated_inventory = inv
		display.associated_id = sorted_inv[p].id
		display.assembly_menu = assembly_menu
		displays.append(display)
	
	
func sort_inv(a, b):
	if a.name < b.name:
		return true
	elif a.name == b.name && a.integrity > b.integrity:
		return true
	return false
	
func erase_display_list():
	for d in displays:
		if(d != null):
			d.queue_free()
		
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed: #Part from mouse data to inventory
		if(assembly_menu != null): ## DROP
			if(assembly_menu.mouse_data.pressed && !assembly_menu.mouse_data.from_inventory && !(assembly_menu.mouse_data.associated_part is PlayerBrain)):
				inv.add_part(assembly_menu.mouse_data.associated_part)
				assembly_menu.mouse_data.associated_part.detach()
				assembly_menu.mouse_data.associated_part.queue_free()
				assembly_menu.clear_mouse_data()
				assembly_menu.refresh()
				assembly_menu.play_detach_sound()
