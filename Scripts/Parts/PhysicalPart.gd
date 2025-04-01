extends RigidBody3D

var part

func look_for_parent_part():
	var parent = get_parent() #Get the part that the bone belong to
	while(!(parent is RobotPart)):
		parent = parent.get_parent()
	return parent

func _ready():
	add_to_group("PhysObj")
	part = look_for_parent_part()

func bullet_hit(damage):
	part.bullet_hit(damage)
	
func explosion(force,ray,pos): #Apply force for an explosion
	var d = (global_transform.origin-pos)
	if d.length() <= ray:
		var appliedforce = ((1-d.length()/ray)**2)*force #Square
		d = d.normalized()
		apply_central_impulse(d*(appliedforce))
		
func directional_explosion(force,ray,pos,direction): #Apply force for a directionnal push
	var d = (global_transform.origin-pos)
	if d.length() <= ray:
		var appliedforce = ((1-d.length()/ray)**2)*force #Square
		apply_central_impulse(direction*(appliedforce))
