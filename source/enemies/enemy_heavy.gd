extends Enemy

const bullet_obj = preload("res://bullets/bullet_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_pattern = [
		{"pos":$ShootPos1, "bullet":bullet_obj, "velocity":Vector2(-15, 200)},
		{"pos":$ShootPos2, "bullet":bullet_obj, "velocity":Vector2(-10, 200)},
		{"pos":$ShootPos3, "bullet":bullet_obj, "velocity":Vector2(10, 200)},
		{"pos":$ShootPos4, "bullet":bullet_obj, "velocity":Vector2(15, 200)}
	]
	score_value = 15
	shot_time = 1.0
	speed = 100
	hp = 4
