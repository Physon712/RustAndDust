extends "res://Scripts/Parts/PartBrain.gd"

@export var target : Robot
@export var move_target : Vector3
@export var target_distance = 3
@export var fov = 90

enum ai_state {IDLE,ENGAGING,CHASING}

var current_state = ai_state.IDLE
var last_known_target_position

@onready var tree = get_tree()

func _ready():
	super()
	
func attach():
	super()
	last_known_target_position = robot.global_position
	move_target = robot.global_position + Vector3.RIGHT

func _physics_process(delta):
	if(robot == null):
		current_state = ai_state.IDLE
		return
	# Main behavior tree
	match(current_state):
		ai_state.IDLE:
			look_for_new_target()
		ai_state.ENGAGING:
			if(target == null || target.brain == null):
				current_state = ai_state.IDLE
			else:
				robot.head.look_at(target.collider.global_position)
				if(is_point_visible(target.collider.global_position)):
					last_known_target_position = target.global_position
					if(robot.weapons.size() > 0):
						robot.weapons[0].use()
				else:
					current_state = ai_state.CHASING
					assign_new_move_target(last_known_target_position)

		ai_state.CHASING:
			look_for_new_target()
			
			
	# Movement
	if(robot.global_position.distance_squared_to(move_target) > target_distance):
		robot.move_direction = move_target-robot.global_position
		robot.head.look_at(move_target + Vector3.UP)
		
	#Aim direction
	if(target != null):
		robot.head.look_at(target.collider.global_position)

func look_for_new_target(): #Look for hostile robot in field of view and assign as target
	var robots = tree.get_nodes_in_group("Robot")
	var min_distance = 999999
	target = null
	for r in robots:
		print(team_signature,robot.name)
		if(r.brain != null && r != robot && (r.brain.team_signature != team_signature || team_signature == GameData.Faction.LONER)):
			var d = global_position.distance_squared_to(r.collider.global_position)
			if(d < min_distance && is_point_visible(r.collider.global_position)):
				print(d,r.name)
				target = r
				min_distance = d
				current_state = ai_state.ENGAGING

func is_point_visible(point):
	var dir = point - robot.head.global_position
	if(rad_to_deg(robot.head.basis.z.angle_to(-dir)) < fov):
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(robot.head.global_position,point,0b001)
		var result = space_state.intersect_ray(query)
		if(result):
			return false
		else:
			return true
	return false

func assign_new_move_target(point):
	move_target = point
		
	
