extends Robot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(Input.is_action_pressed("Jump")):
		action_jump()
	move_direction = Vector2.ZERO
	if(Input.is_action_pressed("Forward")):
		move_direction.x += 1
	if(Input.is_action_pressed("Backward")):
		move_direction.x -= 1
	if(Input.is_action_pressed("Right")):
		move_direction.y += 1
	if(Input.is_action_pressed("Left")):
		move_direction.y -= 1
	super(delta)
