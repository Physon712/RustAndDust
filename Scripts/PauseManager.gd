extends Node

@onready var menu = $Menu

func _ready():
	menu.visible = false
	reparent.call_deferred(get_tree().get_root())#Move outside of scene to avoid being paused
	
	
func _process(_delta):
	if(Input.is_action_just_pressed("Pause")):
		var paused = get_tree().paused
		if(paused): #Unpause
			get_tree().paused = false
			GameData.unpause()
			menu.visible = false
		else: #Pause
			get_tree().paused = true
			GameData.pause()
			menu.visible = true
			
			
func quit():
	get_tree().quit()

func resume():
	get_tree().paused = false
	GameData.unpause()
	menu.visible = false

func reset():
	get_tree().reload_current_scene()
	get_tree().paused = false
	GameData.unpause()
	menu.visible = false
	queue_free()
	
func modify_mouse_sensitivity(value):
	GameData.mouse_sensivity = float(value)*0.005
	
func hide():
	menu.visible = false
