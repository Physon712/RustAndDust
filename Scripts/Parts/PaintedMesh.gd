extends MeshInstance3D

@export var material_id = 0

var part

func look_for_parent_part():
	var parent = get_parent() #Get the part that the bone belong to
	while(!(parent is RobotPart)):
		parent = parent.get_parent()
	return parent

func _ready():
	part = look_for_parent_part()
	set_surface_override_material(material_id,part.paint_material)
	
