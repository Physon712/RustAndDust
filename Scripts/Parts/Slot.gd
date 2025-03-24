extends Node3D

class_name Slot

@export var slot_prefix = ""
@export var slot_type : GameData.PartType = GameData.PartType.CORE

@onready var front_name = slot_prefix + " " + GameData.part_type_name[slot_type]
