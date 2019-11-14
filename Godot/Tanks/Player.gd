extends "res://Tanks/Tank.gd"

export (int) var engine_power = 75 # for acceleration
export (float) var friction = 0.925

func control(delta):
	# (overrides the control function of the parent class
	$Turret.look_at(get_global_mouse_position())
	
	# Turning
	var rot_dir = 0
	if Input.is_action_pressed("turn_right"):
		rot_dir += 1
	if Input.is_action_pressed("turn_left"):
		rot_dir -= 1
	rotation += rotation_speed * rot_dir * delta
	# Moving
	if Input.is_action_pressed("forward"):
		vel = Vector2(vel.length() + engine_power,0).rotated(rotation)
	if Input.is_action_pressed("back"):
		# Can't figure out how to gradually decrease velocity, vel.length() is an absolute value
		# If I do -=, velocity will slow down realistically, but there will be sliding
		vel = Vector2(-250,0).rotated(rotation)		
	# Friction
	vel *= friction
	# Shooting
	if Input.is_action_pressed("click"):
		shoot()

func control_mouse(delta):
	# Rotate towards the mouse
	$Body.look_at(get_global_mouse_position())
	$Turret.look_at(get_global_mouse_position())
	if (get_global_mouse_position() - $Body.global_position).length() > 150:
		vel = Vector2(vel.length() + engine_power,0).rotated($Body.rotation)	
	# Friction
	vel *= friction
	# Shooting
	if Input.is_action_pressed("click"):
		shoot()
		
func control_simple(delta):
	# (overrides the control function of the parent class
	$Turret.look_at(get_global_mouse_position())
	
	var turn = Vector2()
	var moving = false
	if Input.is_action_pressed("turn_right"):
		turn.x += 1
		moving = true
	if Input.is_action_pressed("turn_left"):
		turn.x -= 1
		moving = true
	if Input.is_action_pressed("forward"):
		turn.y -= 1
		moving = true
	if Input.is_action_pressed("back"):
		turn.y += 1
		moving = true
		
	if moving:
		rotation = turn.angle()
		var acc = turn.normalized() * engine_power
		vel += acc
	

	# Friction
	vel *= friction
	# Shooting
	if Input.is_action_pressed("click"):
		shoot()
		
func die():
	emit_signal('dead')