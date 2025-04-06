extends Node

class_name Inventory

var inv = {}
var id_count = 0

func add_part(part : RobotPart):
	if(part.integrity <= 0):
		return
	var children = part.get_slot_parts(part)
	for c in children: #Take also the attached parts
		add_part(c)
	inv[id_count] = {
		"path" : part.scene_file_path,
		"name" : part.front_name,
		"integrity" : part.integrity,
		"max_integrity" : part.max_integrity,
		"type" : part.get_part_type(),
		"color1" : part.paint_color,
		"stat_info" : "",
		"description" : "A robot part"
	}
	part.detach()
	part.queue_free()
	id_count += 1
	print(inv)
	
func remove_part(id):
	inv.erase(id)
	
func instantiate_part(parent,id):
	var p = load(inv[id].path).instantiate()
	parent.add_child(p)
	p.integrity = inv[id].integrity
	p.paint_color = inv[id].color1
	
	
