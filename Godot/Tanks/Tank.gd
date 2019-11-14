extends KinematicBody2D

signal shoot
signal health_changed
signal dead

export (PackedScene) var Bullet
export (float) var rotation_speed = 5
export (float) var gun_cooldown = 0.4
export (int) var max_health = 100

var vel = Vector2()
var can_shoot = true
var alive = true
var health 

func _ready():
	health = max_health
	# Send the percentage of remaining health to the healthbar
	emit_signal('health_changed', health * 100/max_health)
	$GunTimer.wait_time = gun_cooldown
	
func control(delta):
	pass
	
func shoot(target=null):
	if can_shoot:
		can_shoot = false
		$GunTimer.start()
		var dir = Vector2(1,0).rotated($Turret.global_rotation)	 # direction of the turret
		# pass target(comes from EnemyTank) along with the signal to bullet
		emit_signal('shoot', Bullet, $Turret/Muzzle.global_position, dir, target)
		$AnimationPlayer.play('muzzle_flash')
		
		
func _physics_process(delta):
	if not alive:
		return
	control(delta)
	move_and_slide(vel)
	
func take_damage(amount):
	health -= amount
	# Send the percentage of remaining health to the healthbar
	emit_signal('health_changed', health * 100/max_health)
	if health <= 0:
		explode()
		
func explode():
	$CollisionShape2D.disabled = true # to prevent additional bullets from hitting the tank
	alive = false # makes physics process for movement stop running
	$Turret.hide()
	$Body.hide()
	$Explosion.show()
	$Explosion.play()
	die()
	
func die():
	# Defined in Player.gd
	pass
	
func _on_Explosion_animation_finished():
	# Delete tank once explosion animation finished playing
	queue_free()	
	
func _on_GunTimer_timeout():
	can_shoot = true
	

