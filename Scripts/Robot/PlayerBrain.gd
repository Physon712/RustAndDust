extends "res://Scripts/Parts/PartBrain.gd"


### Basically take player input, to control a robot

func attach():
	super()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if(robot.weapons.size() > 0 && Input.is_action_pressed("Fire")):
		robot.weapons[0].use()
	if(robot.weapons.size() > 1 && Input.is_action_pressed("Fire2")):
		robot.weapons[1].use()

func _physics_process(delta):
	if(Input.is_action_pressed("Jump")):
		robot.action_jump()
	robot.move_direction = Vector3.ZERO
	if(Input.is_action_pressed("Forward")):
		robot.move_direction.z -= 1
	if(Input.is_action_pressed("Backward")):
		robot.move_direction.z += 1
	if(Input.is_action_pressed("Right")):
		robot.move_direction.x += 1
	if(Input.is_action_pressed("Left")):
		robot.move_direction.x -= 1
		
	robot.move_direction = robot.move_direction.rotated(Vector3.UP,robot.head.rotation.y)
	
func _input(event):  		
	if event is InputEventMouseMotion:
		robot.head.rotation.y += -GameData.mouse_sensivity*event.relative.x
		robot.head.rotation.x += -GameData.mouse_sensivity*event.relative.y
		robot.head.rotation.x = clamp(robot.head.rotation.x,-1.5,1.5)


func look_for_parent_robot():
	var parent = get_parent() #Get the robot that the part is parented to 
	while(!(parent is Robot)):
		parent = parent.get_parent()
	return parent
