extends "res://Scripts/Parts/PartBrain.gd"

var target : Robot
var last_attacker : Robot
var move_target : Vector3
var focus_target : Vector3
@export var target_distance = 3
@export var fov = 90
@export var aim_error_amplitude:float = 1 #In Degrees
@export var aim_convergence : float = 0.1
@export var ideal_distance : float = 15
@export var hearing_distance : float = 5
@export var cruel : bool = true
@export var look_for_leader = false #Look for a leader to follow once they are activated
var leader:Robot = null

enum ai_state {IDLE,ENGAGING,CHASING,FLEEING}

var current_state = ai_state.IDLE
var last_known_target_position

var follow_path = false
var focus_point = focus_target
var aim_error : Vector2

var stuck_timer = 0.0

@onready var tree = get_tree()

func _ready():
	super()
	
func attach():
	super()
	

var aim_error_delay = 1.0
func _physics_process(delta):
	if(robot == null):
		current_state = ai_state.IDLE
		return
		
	if(look_for_leader && (leader == null || leader.brain == null)):
		look_for_new_leader()
		
	# Main behavior state machine
	match(current_state):
		ai_state.IDLE: #Look for target
			look_for_new_target()
			if(leader != null):
				if(robot.global_position.distance_to(leader.global_position) > 6):
					assign_new_move_target(leader.global_position)
			elif(!follow_path || robot.nav.is_navigation_finished()):
				wander_to_random_point()
				
		ai_state.ENGAGING: #Engage current target until complete destruction
			if(target == null || target.brain == null): #Target down
				stop_path()
				current_state = ai_state.IDLE
			else:
				var dis_to_target = robot.head.global_position.distance_to(target.collider.global_position)
				if(is_point_visible_absolute(target.collider.global_position)):
					last_known_target_position = target.global_position
					
					var should_get_closer = false
					for w in robot.weapons:
						var total_inaccuracy = w.evaluate_total_inaccuracy()
						var instability_inaccuracy = robot.inaccuracy
						
						if(25.0/total_inaccuracy > dis_to_target): #Try to shoot if has a good enough chance to hit or just have plenty of ammo
							w.use()
						
						if(dis_to_target > 25.0/(total_inaccuracy-instability_inaccuracy)):
							should_get_closer = true
						
						
					if(should_get_closer): #If couldn't shoot because way too far, then get closer
						assign_new_move_target(target.global_position)
					else:
						stop_path()
						
				else:
					current_state = ai_state.CHASING
					if(last_known_target_position != null):
						assign_new_move_target(last_known_target_position)
				if(!target.is_armed()): #If target already pacified look for other targets
						look_for_new_target()

		ai_state.CHASING: #Look for target
			look_for_new_target()
			if(robot.nav.is_navigation_finished()):
				current_state = ai_state.IDLE
		
		ai_state.FLEEING: #Get out of here and fast, flee from the last attacker
			target = null
			if(last_attacker != null && !(leader != null)): #In case i'm alone just run from the danger
				assign_new_move_target(robot.global_position - (last_attacker.global_position - robot.global_position))
			if(leader != null): #If i have a leader, regroup with it
				if(robot.global_position.distance_to(leader.global_position) > 6):
					assign_new_move_target(leader.global_position)
					
			if(robot.is_armed()):
				current_state = ai_state.IDLE
			
	if(!robot.is_armed()):
		current_state = ai_state.FLEEING
		
		
	if(follow_path):
		move_target = robot.nav.get_next_path_position()
	# Movement
	if(robot.global_position.distance_squared_to(move_target) > target_distance):
		robot.move_direction = move_target-robot.global_position
		if(robot.velocity.length_squared() > 0.1):
			stuck_timer = 0.0
			focus_target = robot.head.global_position + robot.velocity
		else:
			stuck_timer += delta
			if(stuck_timer > 1.0):
				robot.action_jump()
		#robot.head.rotation.x = lerp(robot.head.rotation.x,0.0,0.1)
	
	if(target != null && current_state == ai_state.ENGAGING):
		focus_target = target.part_core.global_position
	
	# Aiming
	aim_error_delay -= delta
	if(aim_error_delay <= 0):
		aim_error_delay = 1
		var dev = deg_to_rad(aim_error_amplitude)
		aim_error = Vector2(randf_range(-dev,dev),randf_range(-dev,dev))
	
	focus_point = lerp(focus_point,focus_target,aim_convergence)
	robot.head.look_at(focus_point)
	robot.head.rotate_x(aim_error.x)
	robot.head.rotate_y	(aim_error.y)
		

func look_for_new_target(): #Look for hostile robot in field of view and assign as target
	var robots = tree.get_nodes_in_group("Robot")
	var min_distance = 999999
	target = null
	for r in robots:
		if(r.brain != null && r != robot && (r.brain.team_signature != team_signature || team_signature == GameData.Faction.LONER)):
			var d = robot.global_position.distance_squared_to(r.collider.global_position)
			if(!r.is_armed()): #Make unarmed opponent less important in the selection
				d = 3*d
				if(!cruel): #If not cruel then ignore unarmed opponents
					d = min_distance + 1
			if(d < min_distance && (is_point_visible(r.collider.global_position) || d < hearing_distance)):
				target = r
				min_distance = d
				current_state = ai_state.ENGAGING
				
func look_for_new_leader(): #Look for teammates that could assumer a leader role
	var robots = tree.get_nodes_in_group("Robot")
	var min_distance = 999999
	leader = null
	for r in robots:
		if(r.brain != null && r != robot && r.brain.team_signature == team_signature && team_signature != GameData.Faction.LONER && r.brain.can_be_leader):
			var d = robot.global_position.distance_squared_to(r.collider.global_position)
			if(d < min_distance):
				min_distance = d
				leader = r

func is_point_visible(point): #Check if we can actually see the point
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
	
func is_point_visible_absolute(point): #Check if a point could be visible from our currrent position
	var dir = point - robot.head.global_position
	if(true):
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
	
func wander_to_random_point():
	var map = robot.nav.get_navigation_map()
	assign_new_move_target(NavigationServer3D.map_get_random_point(map,1,true))
	
func stop_path():
	move_target = robot.global_position
	follow_path = false
		
func sense_damage(damage,responsible):
	if(responsible != null): #Take a good look at the aggressor
		last_attacker = responsible
		if(robot.is_armed()):
			target = responsible
			current_state = ai_state.ENGAGING
		#if(target == null || target.brain == null || target.weapons.size() <= 0):
			#target = responsible.collider.global_position
	
