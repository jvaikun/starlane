extends Enemy

const PLAY_AREA = Rect2(0, 0, 920, 720)

var bullet_obj = preload("res://bullets/bullet_enemy.tscn")

signal boss_dead


# Called when the node enters the scene tree for the first time.
func _ready():
	score_value = 500
	shot_time = 0.2
	shot_pattern = [
		{"pos":$FirePos1, "bullet":bullet_obj, "velocity":Vector2(-150, 200)},
		{"pos":$FirePos1, "bullet":bullet_obj, "velocity":Vector2(-100, 200)},
		{"pos":$FirePos1, "bullet":bullet_obj, "velocity":Vector2(100, 200)},
		{"pos":$FirePos1, "bullet":bullet_obj, "velocity":Vector2(150, 200)}
	]
	hp = 24
	speed = 200
	$ShootTimer.start(shot_time)


func die():
	if !is_queued_for_deletion():
		enemy_dead.emit(score_value)
		boss_dead.emit()
		var explode_inst = explode_obj.instantiate()
		get_parent().add_child(explode_inst)
		explode_inst.global_position = global_position
		queue_free()

