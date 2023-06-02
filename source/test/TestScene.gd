extends Control

const enemy_obj = preload("res://enemies/EnemyDrone.tscn")

var screen_size = Vector2.ZERO
var generator = MissionGen.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(1)
	screen_size = get_viewport_rect().size


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$Player/AnimationPlayer.play("warp")


func spawn_wave():
	var this_wave = generator.SPAWNS[randi() % generator.SPAWNS.size()]
	for i in 2:
		for pos in this_wave.pattern:
			var enemy_inst = enemy_obj.instance()
			add_child(enemy_inst)
			#enemy_inst.connect("enemy_dead", self, "update_score")
			enemy_inst.global_position.x = pos.position.x * screen_size.x
			enemy_inst.global_position.y = pos.position.y * screen_size.y
			enemy_inst.move_pattern.set_script(load("res://data/%s.gd" % pos.move))
			enemy_inst.move_pattern.speed = pos.speed
			enemy_inst.move_pattern.time_scale = pos.time_scale
			enemy_inst.move_pattern.flip_h = pos.flip_h
			yield(get_tree().create_timer(pos.delay), "timeout")
		yield(get_tree().create_timer(this_wave.repeat_delay), "timeout")


func _on_Timer_timeout():
	spawn_wave()
	#$Timer.stop()
