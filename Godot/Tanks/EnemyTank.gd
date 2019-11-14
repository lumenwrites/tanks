extends "res://Tanks/Tank.gd"


export (int) var max_speed = 200
export (float) var turret_speed = 5
export (int) var detect_radius = 1000

var speed = 0
onready var parent = get_parent() # if parent is PathFollow2D tank will follow the path
var target = null

func _ready():
	# Create a circle that will activate attack when player tank is in radius
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius
	
func control(delta):
	if parent is PathFollow2D:
		if $LookAhead1.is_colliding() or  $LookAhead2.is_colliding():
			# If something is in front of the tank - slowdown to a stop
			speed = lerp(speed,0,0.1)
		else:
			# If there's nothing in front of it - speed up
			speed = lerp(speed,max_speed,0.05)
		parent.set_offset(parent.get_offset() + speed * delta)
		position = Vector2(0,0)
	else:
		# other movement code
		pass
	
func _process(delta):
	if target:
		# If there's a target - aim a turret
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1,0).rotated($Turret.global_rotation)
		# Gradually turn turret in the desired direction
		# linear_interpolate will move it by turret_speed*delta this tick, Im assuming
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()
		# Tank should fire only when turret is pointing at player
		# Use dot product to find the angle
		if target_dir.dot(current_dir) > 0.9:
			shoot(target)
			
func _on_DetectRadius_body_entered(body):
	target = body


func _on_DetectRadius_body_exited(body):
	if body == target: #
		target = null
