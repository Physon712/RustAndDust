extends "res://Scripts/Parts/PartBrain.gd"

### Basically take player input, to control a robot
##As well as display information about the robot in control

#Load all the menu the player will be able to open
@export var hud_prefab = preload("res://Prefabs/UI/robot_hud.tscn")
@export var assembly_menu_prefab = preload("res://Prefabs/UI/assembly_menu.tscn")

@export var inv_prefab = preload("res://Prefabs/inventory.tscn")


var inv = null
var hud = null

var frozen = false

func ready():
	team_signature = GameData.Faction.PLAYER

func attach():
	super()
	if(inv == null):
		if(world.has_node("PlayerInventory")): #In case the inventory has already been created
			inv = world.get_node("PlayerInventory")
		else:
			inv = inv_prefab.instantiate()
			inv.name = "PlayerInventory"
			world.add_child.call_deferred(inv)
	if(hud == null):
		hud = hud_prefab.instantiate()
		world.add_child.call_deferred(hud)
	hud.robot = robot
	hud.evaluate_robot()
	
func detach():
	super()
	if(hud != null):
		hud.queue_free()

func _process(delta):
	super(delta)
	if(robot == null):
		return
	if(robot.camera != null):
		robot.camera.current = true
	
	if(frozen || GameData.in_menu):
		return
	
	if(robot.weapons.size() > 0 && Input.is_action_pressed("Fire")):
		robot.weapons[0].use()
	if(robot.weapons.size() > 1 && Input.is_action_pressed("Fire2")):
		robot.weapons[1].use()

func _physics_process(delta):
	super(delta)
	if(robot == null || frozen || GameData.in_menu):
		return
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
	
	if(Input.is_action_just_pressed("Use")):
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(robot.head.global_position,robot.head.global_position-3*robot.head.basis.z,0b100)
		var result = space_state.intersect_ray(query)
		if(result):
			if(!result.collider.part.is_attached):
				#Take part and put in inventory
				if(result.collider.part.integrity >= 0):
					inv.add_part(result.collider.part)
				else:
					pass
			else:
				#Or modify robot the part belongs to
				if(result.collider.part.robot != robot):
					open_inventory(result.collider.part.robot)
					
		else:
			return  null
	
	if(Input.is_action_just_pressed("Inventory")):
		open_inventory(null)
	
func _input(event):  
	if(robot == null || frozen || GameData.in_menu):
		return		
	if event is InputEventMouseMotion:
		robot.head.rotation.y += -GameData.mouse_sensivity*event.relative.x
		robot.head.rotation.x += -GameData.mouse_sensivity*event.relative.y
		robot.head.rotation.x = clamp(robot.head.rotation.x,-1.5,1.5)


func look_for_parent_robot():
	var parent = get_parent() #Get the robot that the part is parented to 
	while(!(parent is Robot)):
		parent = parent.get_parent()
	return parent

func open_inventory(target):
	var assembly_menu = assembly_menu_prefab.instantiate()
	world.add_child(assembly_menu)
	assembly_menu.robot_a = robot
	assembly_menu.robot_b = target
	assembly_menu.inventory = inv
	assembly_menu.initialize()
	GameData.enter_menu_mode()
	
