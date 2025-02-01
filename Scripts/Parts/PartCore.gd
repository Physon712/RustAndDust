extends "res://Scripts/Parts/RobotPart.gd"

### The CORE is needed for the robot to work

var right_arm = null
var left_arm = null
var movement_module = null

var height = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	initialize()
	
func initialize():
	right_arm = $SlotArmR.get_child(0)
	left_arm = $SlotArmL.get_child(0)
	movement_module = $SlotMovement.get_child(0)

func _physics_process(delta):
	rotation.y = robot.head.rotation.y
	transform.origin.y = height
	if(movement_module != null):
		transform.origin.y = movement_module.height
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
