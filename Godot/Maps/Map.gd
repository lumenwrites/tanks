extends Node2D

 
func _ready():
	set_camera_limits()
	Input.set_custom_mouse_cursor(
		load("res://spritesheets/UI/crossair_black.png"),
		Input.CURSOR_ARROW, Vector2(16,16)
	)
	
func set_camera_limits():
	# How much space map is using (in tiles)
	var map_limits = $Ground.get_used_rect()
	var map_cellsize = $Ground.cell_size
	#$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	#$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	#$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.x
	#$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.x
	
func _on_Tank_shoot(bullet, _position, _direction, _target=null):
	# Tank.g emits shoot signal, this catches it
	# Create a bullet
	var b = bullet.instance()
	add_child(b)
	# Bullet.gd has a start function that accepts position and direction
	b.start(_position, _direction, _target)
	# EnemyTank notices player enter it's field of view, sets it as target,
	# calls shoot() method of Tank, which passes it alnong with the signal here,
	# and we pass it along to bullet

func _on_Player_dead():
	# restart level
	get_tree().reload_current_scene()
