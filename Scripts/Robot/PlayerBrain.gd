extends "res://Scripts/Parts/PartBrain.gd"

## Basically take player input, to control a robot
##as well as display information about the controlled robot
class_name PlayerBrain

#Load all the menu the player will be able to open
var hud_prefab = preload("res://Prefabs/UI/robot_hud.tscn")
var assembly_menu_prefab = preload("res://Prefabs/UI/assembly_menu.tscn")
var inv_prefab = preload("res://Prefabs/inventory.tscn")

var ghost_cam_prefab = preload("res://Prefabs/player_ghost.tscn")


var inv = null
var hud = null

var frozen = false
var mouse_sensitivity_mult = 1.0

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
	if(robot == null): #Dead
		if(hud != null):
			hud.queue_free()
		release_ghost_camera()
		queue_free()
		return
	if(robot.camera != null):
		robot.camera.current = true
	
	if(frozen || GameData.in_menu):
		return
	
	#Weapon usage
	if(robot.weapons.size() > 0 && Input.is_action_pressed("Fire")):
		robot.weapons[0].use()
	if(robot.weapons.size() > 1 && Input.is_action_pressed("Fire2")):
		robot.weapons[1].use()
	if(robot.weapons.size() > 2 && Input.is_action_pressed("Fire3")):
		robot.weapons[2].use()
		

func _physics_process(delta):
	super(delta)
	if(robot == null || frozen || GameData.in_menu):
		return
		
	# Directionnal Input
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
	
	#Zoom
	if(Input.is_action_pressed("Zoom")):
		robot.camera.fov = lerp(robot.camera.fov,35.0,0.2)
		mouse_sensitivity_mult = 0.5
	else:
		robot.camera.fov = lerp(robot.camera.fov,75.0,0.2)
		mouse_sensitivity_mult = 1
		
	#Interaction raycast
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(robot.head.global_position,robot.head.global_position-3*robot.head.basis.z,0b100)
	var result = space_state.intersect_ray(query)
	if(result):
		if(hud != null && hud.use_hint != null): 
			if(result.collider.part.integrity >	 0.0):
				hud.use_hint.text = result.collider.part.front_name + " [" + str(round(100*float(result.collider.part.integrity)/result.collider.part.max_integrity)) + "%]"
			else:
				hud.use_hint.text = result.collider.part.front_name + "[BROKEN]"
		if(Input.is_action_just_pressed("Use")):
			if(!result.collider.part.is_attached):
				#Take part and put in inventory
				if(result.collider.part.integrity >= 0):
					inv.add_part(result.collider.part)
				else:
					pass
			else:
				#Or modify the robot from the part in case it is still attached
				if(result.collider.part.robot != robot):
					open_inventory(result.collider.part.robot)
	else:
		if(hud != null && hud.use_hint != null): 
			hud.use_hint.text = ""

	
	if(Input.is_action_just_pressed("Inventory")):
		open_inventory(null)
	
func _input(event):  #Mouse input
	if(robot == null || frozen || GameData.in_menu):
		return		
	if event is InputEventMouseMotion:
		robot.head.rotation.y += -GameData.mouse_sensivity*event.relative.x*mouse_sensitivity_mult
		robot.head.rotation.x += -GameData.mouse_sensivity*event.relative.y*mouse_sensitivity_mult
		robot.head.rotation.x = clamp(robot.head.rotation.x,-1.5,1.5)


func look_for_parent_robot():
	var parent = get_parent() #Get the robot to which the part is parented
	while(!(parent is Robot)):
		parent = parent.get_parent()
		if(parent == null):
			return null
	return parent

func open_inventory(target): #Create an assembly menu between the current robot and the target one
	var assembly_menu = assembly_menu_prefab.instantiate()
	world.add_child(assembly_menu)
	assembly_menu.robot_a = robot
	assembly_menu.robot_b = target
	assembly_menu.inventory = inv
	assembly_menu.initialize()
	GameData.enter_menu_mode()
	
func release_ghost_camera():
	var ghost = ghost_cam_prefab.instantiate()
	world.add_child(ghost)
	ghost.global_position = global_position + 3*basis.z
	ghost.look_at(global_position)
	
