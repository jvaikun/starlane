extends "res://enemies/Enemy.gd"

var bullet_obj = preload("res://bullets/BulletEnemy.tscn")
var path = []
var destination = 0

signal boss_dead

func set_hp(value):
	hp = value
	if hp <= 0:
		emit_signal("boss_dead")


# Called when the node enters the scene tree for the first time.
func _ready():
	score_value = 500
	destination = 0
	shot_time = 0.2
	shot_pattern = [
		{"pos":$FirePos1, "bullet":bullet_obj, "velocity":Vector2(-150, 200)},
		{"pos":$FirePos1, "bullet":bullet_obj, "velocity":Vector2(-100, 200)},
		{"pos":$FirePos1, "bullet":bullet_obj, "velocity":Vector2(100, 200)},
		{"pos":$FirePos1, "bullet":bullet_obj, "velocity":Vector2(150, 200)}
	]
	hp = 24
	speed = 150
	path = [
		Vector2(64, 64),
		Vector2(get_viewport_rect().size.x - 64, 64)
	]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.global_position.distance_to(path[destination]) < 4:
		destination += 1
		if destination >= path.size():
			destination = 0
	else:
		direction = (path[destination] - self.global_position)

