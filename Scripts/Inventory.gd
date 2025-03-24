extends Node

class_name Inventory

var inv = {}
var id_count = 0

func add_part(part : RobotPart):
	inv[id_count] = {
		"path" : part.scene_file_path,
		"name" : part.front_name,
		"integrity" : part.integrity,
		"max_integrity" : part.max_integrity,
		"type" : part.get_part_type()
	}
	id_count += 1
	print(inv)
	
func remove_part(id):
	inv.erase(id)
	
func instantiate_part(slot,id):
	var p = load(inv[id].path).instantiate()
	slot.add_child(p)
	p.integrity = inv[id].integrity
