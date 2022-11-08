extends Control

enum GameState {TITLE, CHOICE, INTRO, PLAY, OUTRO, PAUSE, END}

const TITLE_TEXT = "Mission: %d"
const MISSION_COUNT = 3
const TICK_TIME = 0.1
const BOSS_WAIT = 2.0
const player_obj = preload("res://player/Player.tscn")

onready var skill1 = $HUDRight/SkillButton
onready var skill2 = $HUDRight/SkillButton2
onready var skill3 = $HUDRight/SkillButton3

var mission_gen = MissionGen.new()
var player = null
var state = GameState.TITLE setget set_state
var level_index = 1
var score = 0
var dir_vector = Vector2.ZERO
var wave_count = 0
var boss_spawned = false
var is_scrolling = false
var screen_size = Vector2.ZERO
var next_missions = []
var active_mission
var time_count = 0.0

func set_state(value):
	if value in GameState.values():
		state = value
		match state:
			GameState.TITLE:
				$MainMenu.show()
				$HUDLeft.hide()
				$HUDRight.hide()
				$GameOver.hide()
			GameState.CHOICE:
				generate_missions()
				$MissionChoice.update_ui(next_missions)
				$MissionChoice.show()
			GameState.INTRO:
				if !is_instance_valid(player):
					player = player_obj.instance()
					add_child(player)
					player.global_position = Vector2(540/2, 960*0.8)
					player.connect("player_dead", self, "game_over")
					player.connect("hp_change", self, "update_hp")
					player.connect("shield_change", self, "update_shield")
					skill1.connect("trigger_skill", player, "fire_weapon1")
					skill2.connect("trigger_skill", player, "fire_weapon2")
					skill3.connect("trigger_skill", player, "fire_weapon3")
				$HUDLeft.show()
				$HUDRight.show()
				$Cutscene/Intro/Title.text = TITLE_TEXT % level_index
				$Cutscene/Intro/Subtitle.text = active_mission.name
				$AnimationPlayer.play("intro_in")
			GameState.PLAY:
				is_scrolling = true
				$SpawnTimer.start(TICK_TIME)
			GameState.OUTRO:
				level_index = clamp(level_index + 1, 1, 12)
				boss_spawned = false
				time_count = 0.0
				wave_count = 0
				player.queue_free()
				$AnimationPlayer.play("outro_in")
			GameState.PAUSE:
				pass
			GameState.END:
				player.queue_free()
				$HUDLeft.hide()
				$HUDRight.hide()
				$GameOver.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	self.state = GameState.TITLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		GameState.PLAY:
			if is_scrolling:
				$ParallaxBackground/ParallaxLayer.motion_offset.y += 128 * delta
			if is_instance_valid(player):
				dir_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
				dir_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
				player.translate(dir_vector.normalized() * 4)
				player.position.x = clamp(player.position.x, 0, screen_size.x)
				player.position.y = clamp(player.position.y, 0, screen_size.y)
			if Input.is_action_just_pressed("ui_weapon1"):
				skill1.fire_skill()
			if Input.is_action_just_pressed("ui_weapon2"):
				skill2.fire_skill()
			if Input.is_action_just_pressed("ui_weapon3"):
				skill3.fire_skill()


func init_game():
	screen_size = get_viewport_rect().size
	$MainMenu.hide()
	$GameOver.hide()
	score = 0
	update_score(0)
	update_hp(5)
	update_shield(3)
	self.state = GameState.CHOICE


func generate_missions():
	next_missions.clear()
	for i in MISSION_COUNT:
		next_missions.append(mission_gen.generate_mission())


func end_mission():
	self.state = GameState.OUTRO


func update_hp(val):
	$HUDLeft/BarHP.value = val


func update_shield(val):
	$HUDLeft/BarShield.value = val


func update_score(val):
	score += val
	$HUDLeft/Score.text = "SCORE:%d" % score


func game_over():
	$SpawnTimer.stop()
	var bullets = get_tree().get_nodes_in_group("bullet")
	var ships = get_tree().get_nodes_in_group("enemies")
	for bullet in bullets:
		bullet.queue_free()
	for ship in ships:
		ship.queue_free()
	self.state = GameState.END


func _on_BtnStart_pressed():
	init_game()


func _on_BtnInstructions_pressed():
	pass # Replace with function body.


func _on_BtnCredits_pressed():
	pass # Replace with function body.


func _on_BtnRestart_pressed():
	init_game()


func _on_BtnQuit_pressed():
	self.state = GameState.TITLE


func _on_SpawnTimer_timeout():
	time_count += 0.1
	if wave_count >= active_mission.waves.size():
		if is_scrolling:
			is_scrolling = false
			$AnimationPlayer.play("warning_flash")
			$SpawnTimer.start(BOSS_WAIT)
		elif !boss_spawned:
			print("Boss time!")
			$AnimationPlayer.play("RESET")
			var boss_inst
			boss_inst = active_mission.boss.instance()
			add_child(boss_inst)
			boss_inst.connect("enemy_dead", self, "update_score")
			boss_inst.connect("boss_dead", self, "end_mission")
			boss_inst.global_position = Vector2(256, 64)
			boss_spawned = true
			$SpawnTimer.stop()
	elif time_count >= active_mission.waves[wave_count].spawn_time:
		print("Time: %d, Enemy wave: %d" % [time_count, wave_count])
		var enemy_inst
		for enemy in active_mission.waves[wave_count].enemies:
			enemy_inst = enemy.scene.instance()
			add_child(enemy_inst)
			enemy_inst.connect("enemy_dead", self, "update_score")
			enemy_inst.global_position = Vector2( 
				enemy.start_position.x * screen_size.x,
				enemy.start_position.y * screen_size.y
			)
		time_count = 0.0
		wave_count += 1


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"intro_in":
			$AnimationPlayer.play("intro_out")
		"intro_out":
			$AnimationPlayer.play("RESET")
			self.state = GameState.PLAY
		"outro_in":
			$AnimationPlayer.play("outro_out")
		"outro_out":
			$AnimationPlayer.play("RESET")
			self.state = GameState.CHOICE


func _on_MissionChoice_mission_choice(num):
	active_mission = next_missions[num]
	$MissionChoice.hide()
	self.state = GameState.INTRO
