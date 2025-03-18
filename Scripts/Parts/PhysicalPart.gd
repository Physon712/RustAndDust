extends RigidBody3D

var part

func look_for_parent_part():
	var parent = get_parent() #Get the part that the bone belong to
	while(!(parent is RobotPart)):
		parent = parent.get_parent()
	return parent

func _ready():
	part = look_for_parent_part()

func bullet_hit(damage):
	part.bullet_hit(damage)
	
