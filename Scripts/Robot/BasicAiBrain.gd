extends "res://Scripts/Parts/PartBrain.gd"

var target : Robot
var last_attacker : Robot
@export var move_target : Vector3
@export var target_distance = 3
@export var fov = 90

enum ai_state {IDLE,ENGAGING,CHASING,FLEEING}

var current_state = ai_state.IDLE
var last_known_target_position

var follow_path = false

@onready var tree = get_tree()

func _ready():
	super()
	
func attach():
	super()

func _physics_process(delta):
	if(robot == null):
		current_state = ai_state.IDLE
		return
		
	if(robot.weapons.size() <= 0):
		current_state = ai_state.FLEEING
		
	# Main behavior tree
	match(current_state):
		ai_state.IDLE: #Look for target
			look_for_new_target()
		ai_state.ENGAGING: #Engage target
			if(target == null || target.brain == null):
				current_state = ai_state.IDLE
			else:
				robot.head.look_at(target.collider.global_position)
				var dis_to_target = robot.head.global_position.distance_to(target.collider.global_position)
				if(is_point_visible(target.collider.global_position)):
					last_known_target_position = target.global_position
					
					var should_get_closer = false
					for w in robot.weapons:
						var total_inaccuracy = w.evaluate_total_inaccuracy()
						var instability_inaccuracy = robot.inaccuracy
						
						if(45.0/total_inaccuracy > dis_to_target): #Try to shoot if has a good enough chance to hit
							w.use()
						
						if(45.0/(total_inaccuracy-instability_inaccuracy) < dis_to_target): #If can't shoot even when not moving, then move
							should_get_closer = true
						
						
					if(should_get_closer): #If couldn't shoot because way too far, then get closer
						assign_new_move_target(target.global_position)
					else:
						stop_path()
						
				else:
					current_state = ai_state.CHASING
					assign_new_move_target(last_known_target_position)

		ai_state.CHASING: #Look for target
			look_for_new_target()
		
		ai_state.FLEEING: #Get out of here and fast, flee the last attacker
			target = null
			if(last_attacker != null):
				assign_new_move_target(robot.global_position - (last_attacker.global_position - robot.global_position))
			
	if(follow_path):
		move_target = robot.nav.get_next_path_position()
	# Movement
	if(robot.global_position.distance_squared_to(move_target) > target_distance):
		robot.move_direction = move_target-robot.global_position
		robot.head.look_at(robot.head.global_position + robot.velocity)
		#robot.head.rotation.x = lerp(robot.head.rotation.x,0.0,0.1)
		
		
	#Aim direction
	if(target != null):
		robot.head.look_at(target.collider.global_position)

func look_for_new_target(): #Look for hostile robot in field of view and assign as target
	var robots = tree.get_nodes_in_group("Robot")
	var min_distance = 999999
	target = null
	for r in robots:
		if(r.brain != null && r != robot && (r.brain.team_signature != team_signature || team_signature == GameData.Faction.LONER)):
			var d = robot.global_position.distance_squared_to(r.collider.global_position)
			if(d < min_distance && is_point_visible(r.collider.global_position)):
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
	follow_path = true
	robot.nav.target_position = point
	move_target = robot.nav.get_next_path_position()
	
func stop_path():
	move_target = robot.global_position
	follow_path = false
		
func sense_damage(damage,responsible):
	if(responsible != null && current_state != ai_state.ENGAGING): #Take a good look at the aggressor
		last_attacker = responsible
		robot.head.look_at(responsible.collider.global_position)
	
