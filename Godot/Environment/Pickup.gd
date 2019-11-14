extends Area2D

enum Items {health, ammo}

var icon_textures = [
	preload("res://effects/spritesheets/wrench_white.png"),
	preload("res://effects/spritesheets/ammo_machinegun.png")
]

export (Items) var type = Items.health
export (Vector2) var amount = Vector2(10,25) # min and max amount of random pickup, between 10 and 25 health

func _ready():
	$Icon.texture = icon_textures[type]
	
func _on_Pickup_body_entered(body):
	match type: # kinda like switch?
		Items.health:
			if body.has_method('heal'): # if it's a player's tank
				body.heal(int(rand_range(amount.x,amount.y)))
		Items.ammo:
			body.ammo += int(rand_range(amount.x,amount.y))
	queue_free()