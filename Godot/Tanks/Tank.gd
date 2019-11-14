extends KinematicBody2D

signal shoot
signal health_changed
signal ammo_changed
signal dead

export (PackedScene) var Bullet
export (float) var rotation_speed = 5
export (float) var gun_cooldown = 0.4
export (int) var max_health = 100
export (int) var max_ammo = 20
export (int) var ammo = -1 setget set_ammo # -1 means infinite ammo
export (int) var gun_shots = 1
export (float, 0, 1.5) var gun_spread = 0.2


var vel = Vector2()
var can_shoot = true
var alive = true
var health 

func _ready():
	health = max_health
	# Send the percentage of remaining health to the healthbar
	emit_signal('health_changed', health * 100/max_health)
	emit_signal('ammo_changed', ammo * 100/max_ammo)
	$GunTimer.wait_time = gun_cooldown
	
func control(delta):
	pass
	
func shoot(num, spread, target=null): # num is a number of shots to fire
	if can_shoot and ammo != 0:
		self.ammo -= 1
		can_shoot = false
		$GunTimer.start()
		var dir = Vector2(1,0).rotated($Turret.global_rotation)	 # direction of the turret
		if num > 1:
			# Shoot multiple bullets
			for i in range(num):
				var angle = -spread + i * (2*spread)/(num-1) 
				emit_signal('shoot', Bullet, $Turret/Muzzle.global_position.rotated(angle), dir, target)
		else:
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
		
func heal(amount):
	health += amount
	health = clamp(health,0,max_health)
	emit_signal('health_changed', health * 100/max_health)
	
	
	
func explode():
	# Triggered by take_damage when health reaches zero
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
	
func set_ammo(value):
	# Because declaring variables at the top ties a function to ammo change,
	# this function runs every time ammo variable changes? So it's triggered by reducing ammo in shoot?
	if value > max_ammo:
		value = max_ammo
	ammo = value
	emit_signal('ammo_changed', ammo * 100/max_ammo)
