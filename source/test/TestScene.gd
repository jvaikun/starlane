extends Control

const enemy_obj = preload("res://enemies/EnemyDrone.tscn")

var screen_size = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.one_shot = true
	$Timer.start(0.5)
	screen_size = get_viewport_rect().size


func _process(delta):
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if (enemy.time < enemy.time_scale * 0.5):
			enemy.direction = Vector2(1, 1)
		else:
			enemy.direction = Vector2(-1, 1)
#		enemy.direction = Vector2(sin(enemy.time), 1)


func _on_Timer_timeout():
	var enemy_inst
	for i in 4:
		enemy_inst = enemy_obj.instance()
		add_child(enemy_inst)
		enemy_inst.time_scale = 2
		enemy_inst.speed = 150
		enemy_inst.global_position = Vector2(0.25 * screen_size.x, 0)
		yield(get_tree().create_timer(0.25), "timeout")
	$Timer.start(0.5)
