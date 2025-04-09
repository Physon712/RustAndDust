extends Node3D

@export var spawn_delay : float = 60
@export var spawn_amount = 3
@export var max_robot = 10

@export var nav_region : NavigationRegion3D

var delay = 0
var nav_map
@onready var world = get_tree().get_current_scene()

var robots = []

@export var robots_prefabs = [
	preload("res://Prefabs/Robots/robot_loner_beta.tscn")]

func _ready():
	nav_map = nav_region.get_navigation_map()

func count_active_robot():
	#var robots = get_tree().get_nodes_in_group("Robot")
	var res = 0
	for r in robots:
		if(r.brain != null):
			res += 1
	return res

func _process(delta):
	delay -= delta
	if(delay <= 0):
		if(count_active_robot() < max_robot):
			for i in range(spawn_amount):
				spawn()
		delay = spawn_delay
			
func spawn():
	var robot_prefab = robots_prefabs[randi_range(0,robots_prefabs.size()-1)]
	var robot = robot_prefab.instantiate()
	robots.append(robot)
	world.add_child(robot)
	robot.global_position = NavigationServer3D.map_get_random_point(nav_map,1,true)
	
