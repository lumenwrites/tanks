extends Area2D

export (int) var speed = 1200
export (int) var damage = 20
export (float) var lifetime = 0.5
export (float) var steer_force = 0

var velocity = Vector2()
var acceleration = Vector2()
var target = null

func start(_position, _direction, _target=null):
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	velocity = _direction * speed
	target = _target
	
func _process(delta):
	if target:
		# Heat seeking missile
		acceleration += seek()
		velocity += acceleration * delta # accelerate towards target
		velocity = velocity.clamped(speed) # restric maximum speed
		rotation = velocity.angle() # match sprite rotation to velocity vector

	position += velocity * delta

func seek():
	# Steering behavior
	# We want to move along the vector between our and target's positions, with length of speed
	var desired = (target.position - position).normalized() * speed	
	# Velocity is the direction we're going in right now
	# this will pull(accelerate?) us towards the desired direction by whatever the steer force is
	var steer = (desired - velocity).normalized() * steer_force
	return steer
	
func explode():
	# Set velocity to 0, so explosion effect doesn't keep moving
	velocity = Vector2()
	$Sprite.hide() # hide bullet
	$Explosion.show() # show explosion
	$Explosion.play("smoke")
	
func _on_Explosion_animation_finished():
	# delete from scene
	queue_free()


	

func _on_Bullet_body_entered(body):
	explode()
	if body.has_method('take_damage'): # if it's enemy tank and not a wall
		# Run this function on the tank bullet collided with
		body.take_damage(damage)


func _on_Lifetime_timeout():
	explode()

