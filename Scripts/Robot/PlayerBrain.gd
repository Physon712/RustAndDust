extends Node

@onready var robot = get_parent() # Get the robot the player controls

### Basically take player input, to control a robot

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

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
