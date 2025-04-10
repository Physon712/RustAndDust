extends Container

@export var robot : Robot
@export var part : RobotPart

@onready var integrity_bar = $Container/Status/Integrity
@onready var name_display = $Container/Status/Label 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initialize():
	$Container/Status/Label.text = part.front_name
	$Container/Status/Integrity.max_value = part.max_integrity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(part != null):
		integrity_bar.value = part.integrity
		if(!part.is_attached):
			queue_free()
	else:
		integrity_bar.value = 0
		
	if(part.integrity <= 0.25*part.max_integrity):
		modulate = Color.RED
	elif(part.integrity <= 0.5*part.max_integrity):
		modulate = Color.ORANGE
	else:	
		modulate = Color.WHITE
