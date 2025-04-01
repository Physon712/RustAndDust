extends "res://Scripts/Parts/PartBrain.gd"

@export var target : Robot
@export var target_distance = 1

@export var fov = 90


func _ready():
	super()
	team_signature = GameData.Faction.SCRAPER

func _process(delta):
	if(robot == null):
		return
	if(robot.weapons.size() > 0):
		robot.weapons[0].use()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(robot == null):
		return
	if(target == null):
		return
		
	var robots = world.get_nodes_in_group()
		
	if(robot.global_position.distance_to(target.global_position) > target_distance):
		robot.move_direction = target.global_position-robot.global_position
	robot.head.look_at(target.collider.global_position)

func is_robot_visible(target):
	var dir = target.collider.global_position - robot.head.global_position
	if(rad_to_deg(-robot.head.basis.z.angle_to(dir)) < fov):
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(robot.head.global_position,dir,0b001)
		var result = space_state.intersect_ray(query)
		if(result):
			return false
		else:
			return true
	return false

func get_visible_robots():
	return
	var robots = world.get_nodes_in_group()
	var shortest_distance = 1000
	for r in robots:
		pass
		
		
	
