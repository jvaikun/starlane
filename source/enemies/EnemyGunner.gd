extends "res://enemies/Enemy.gd"

const bullet_obj = preload("res://bullets/BulletEnemy.tscn")

onready var shot_pattern = [
	{"pos":$ShootPos1, "bullet":bullet_obj, "velocity":Vector2(0, 200)},
	{"pos":$ShootPos2, "bullet":bullet_obj, "velocity":Vector2(0, 200)}
]

# Called when the node enters the scene tree for the first time.
func _ready():
	score_value = 10
	speed = 100
	hp = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func shoot():
	var bullet_inst
	for shot in shot_pattern:
		bullet_inst = shot.bullet.instance()
		get_parent().add_child(bullet_inst)
		bullet_inst.global_position = shot.pos.global_position
		bullet_inst.velocity = shot.velocity

func _on_ShootTimer_timeout():
	shoot()
