extends Control

enum GameState {TITLE, CHOICE, INTRO, PLAY, OUTRO, PAUSE, END}

const enemy_obj = preload("res://enemies/enemy_drone.tscn")
const hazard_obj = preload("res://hazards/asteroid.tscn")
const PLAY_AREA = Rect2(0, 0, 920, 720)
const TITLE_TEXT = "Mission: %d"
const START_WAIT = 1.0
const BOSS_WAIT = 2.0
const HOME_POS = Vector2(0.5, 0.8)

@onready var player = $Player
@onready var skill1 = $UI/HUD/Content/Equip/SkillButton
@onready var skill2 = $UI/HUD/Content/Equip/SkillButton2
@onready var skill3 = $UI/HUD/Content/Equip/SkillButton3

var state = GameState.PLAY
var level_index = 1
var score = 0
var dir_vector = Vector2.ZERO
var time_count = 0.0
var generator = MissionGen.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.warp_in()
	$SpawnTimer.start(1)
	player.global_position = PLAY_AREA.size * HOME_POS
	player.connect("hp_change", Callable(self, "update_hp"))
	player.connect("shield_change", Callable(self, "update_shield"))
	skill1.connect("trigger_skill", Callable(player, "fire_weapon1"))
	skill2.connect("trigger_skill", Callable(player, "fire_weapon2"))
	skill3.connect("trigger_skill", Callable(player, "fire_weapon3"))


func _process(delta):
	if state == GameState.PLAY:
		if is_instance_valid(player):
			dir_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			dir_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			player.translate(dir_vector.normalized() * 4)
			player.position.x = clamp(player.position.x, 0, PLAY_AREA.size.x)
			player.position.y = clamp(player.position.y, 0, PLAY_AREA.size.y)
		if Input.is_action_just_pressed("ui_weapon1"):
			skill1.fire_skill()
		if Input.is_action_just_pressed("ui_weapon2"):
			skill2.fire_skill()
		if Input.is_action_just_pressed("ui_weapon3"):
			skill3.fire_skill()


func spawn_wave():
	var this_wave = generator.SPAWNS[randi() % generator.SPAWNS.size()]
	for i in 2:
		for pos in this_wave.pattern:
			var enemy_inst = enemy_obj.instantiate()
			add_child(enemy_inst)
			#enemy_inst.connect("enemy_dead", self, "update_score")
			enemy_inst.global_position.x = pos.position.x * PLAY_AREA.size.x
			enemy_inst.global_position.y = pos.position.y * PLAY_AREA.size.y
			enemy_inst.move_pattern.set_script(load("res://data/%s.gd" % pos.move))
			enemy_inst.move_pattern.speed = pos.speed
			enemy_inst.move_pattern.time_scale = pos.time_scale
			enemy_inst.move_pattern.flip_h = pos.flip_h
			await get_tree().create_timer(pos.delay).timeout
		await get_tree().create_timer(this_wave.repeat_delay).timeout


func spawn_hazard():
	var hazard_inst = hazard_obj.instantiate()
	add_child(hazard_inst)
	hazard_inst.global_position = Vector2(PLAY_AREA.size.x * ((randi() % 10) * 0.1), 16)


func _on_spawn_timer_timeout():
	spawn_hazard()
	#spawn_wave()

