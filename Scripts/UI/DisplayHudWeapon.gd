extends Control

@export var robot : Robot
@export var weapon_id : int = 0

@onready var labels = [$Status/Label,$Status/Label2,$Status/Label3]

var has_ammo = false

func initialize():
	labels = [$Status/Label,$Status/Label2,$Status/Label3]
	labels[1].text = robot.weapons[weapon_id].front_name
	match(weapon_id):
		0:
			labels[0].text = "[LMB]"
		1:
			labels[0].text = "[RMB]"
		2:
			labels[0].text = "[A]"
	if("ammo" in robot.weapons[weapon_id]):
		has_ammo = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(has_ammo && false):
		labels[2].text = str(robot.weapons[weapon_id].ammo)+ "/" +str(robot.weapons[weapon_id].max_ammo)
	else:
		labels[2].text = ""
