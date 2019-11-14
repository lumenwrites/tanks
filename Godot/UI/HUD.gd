extends CanvasLayer

var bar_red = preload("res://spritesheets/UI/barHorizontal_red_mid 200.png")
var bar_green = preload("res://spritesheets/UI/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://spritesheets/UI/barHorizontal_yellow_mid 200.png")
var bar_texture

func update_healthbar(value):
	bar_texture = bar_green
	if value < 60:
		bar_texture = bar_yellow
	if value < 25:
		bar_texture = bar_red
	
	$Margin/HBox/HealthBar.texture_progress = bar_texture
	# Animate health decrease of HealthBar
	$Margin/HBox/HealthBar/Tween.interpolate_property(
		$Margin/HBox/HealthBar, 'value', # Change it's 'value' property
		$Margin/HBox/HealthBar.value,value, # from it's current value to the value passed to this function
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT # over 0.2 seconds, linearly, with ease in/out
	)
	$Margin/HBox/HealthBar/Tween.start()
	$AnimationPlayer.play("healthbar_flash") # play animation
	# $Margin/HBox/HealthBar.value = value

func _on_AnimationPlayer_animation_finished(anim_name):
	# After animation is finished, healthbar is set to red (by keyframes)
	# Set it to correct color
	if anim_name == "healthbar_flash":
		$Margin/HBox/HealthBar.texture_progress = bar_texture
		
