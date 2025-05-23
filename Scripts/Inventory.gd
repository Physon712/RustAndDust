extends Node

class_name Inventory

var inv = {}
var id_count = 0

var friendly_ai = preload("res://Prefabs/Brains/basic_ai_brain_friends.tscn")
func _ready(): #Give starter Pack
	id_count = 0
	for i in range(3):
		var obj = friendly_ai.instantiate()
		obj.integrity = obj.max_integrity
		add_part(obj)

func add_part(part : RobotPart): #Add part to inventory along with it's part attached
	if(part.integrity <= 0):
		return
	var children = part.get_slot_parts(part)
	for c in children: #Take also the attached parts
		if(c is PlayerBrain): #Can't pocket your own brain
			c.detach() #Will kill you
		else:
			add_part(c)
	inv[id_count] = {
		"id" : id_count,
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

	
func remove_part(id):
	inv.erase(id)
	
func instantiate_part(parent,id):
	var p = load(inv[id].path).instantiate()
	parent.add_child(p)
	p.integrity = inv[id].integrity
	p.paint_color = inv[id].color1
	return p
	
	
