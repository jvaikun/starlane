extends Control

enum GameState {TITLE, CHOICE, INTRO, PLAY, OUTRO, PAUSE, END}

const PLAY_AREA = Rect2(370, 0, 540, 720)
const TITLE_TEXT = "Mission: %d"
const START_WAIT = 1.0
const BOSS_WAIT = 2.0
const HOME_POS = Vector2(0.5, 0.8)
const player_obj = preload("res://player/player.tscn")
const enemy_obj = preload("res://enemies/enemy_drone.tscn")

@onready var skill1 = $UI/HUD/Content/Equip/SkillButton
@onready var skill2 = $UI/HUD/Content/Equip/SkillButton2
@onready var skill3 = $UI/HUD/Content/Equip/SkillButton3

var mission_gen = MissionGen.new()
var player = null
var state = GameState.TITLE: set = set_state
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
				level_index = 1
				score = 0
				dir_vector = Vector2.ZERO
				wave_count = 0
				boss_spawned = false
				is_scrolling = false
				$UI/HUD.hide()
				$UI/Cutscene.hide()
				$UI/Title.show()
				$UI/GameOver.hide()
				$UI/StarMap.hide()
			GameState.CHOICE:
				wave_count = 0
				boss_spawned = false
				is_scrolling = false
				$UI/HUD.show()
				$UI/Cutscene.hide()
				$UI/Title.hide()
				$UI/GameOver.hide()
				$UI/StarMap.gen_paths()
				$UI/StarMap.show()
			GameState.INTRO:
				spawn_player()
				player.warp_in()
				$UI/HUD.show()
				$UI/Title.hide()
				$UI/GameOver.hide()
				$UI/StarMap.hide()
				$UI/Cutscene.show()
				$UI/Cutscene/Intro/Title.text = TITLE_TEXT % level_index
				$UI/Cutscene/Intro/Subtitle.text = active_mission.name
				$AnimationPlayer.play("intro_in")
			GameState.PLAY:
				is_scrolling = true
				$SpawnTimer.start(START_WAIT)
			GameState.OUTRO:
				level_index += 1
				boss_spawned = false
				time_count = 0.0
				wave_count = 0
				player.warp_out()
				$AnimationPlayer.play("outro_in")
			GameState.PAUSE:
				pass
			GameState.END:
				player.queue_free()
				$UI/HUD.hide()
				$UI/Title.hide()
				$UI/GameOver.show()
				$UI/StarMap.hide()
				$UI/Cutscene.hide()

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
	score = 0
	update_score(0)
	update_hp(5)
	update_shield(5)
	self.state = GameState.CHOICE


func clear_screen():
	var bullets = get_tree().get_nodes_in_group("bullet")
	var ships = get_tree().get_nodes_in_group("enemies")
	for bullet in bullets:
		bullet.queue_free()
	for ship in ships:
		ship.queue_free()


func spawn_player():
	if !is_instance_valid(player):
		player = player_obj.instantiate()
		add_child(player)
		player.global_position = screen_size * HOME_POS
		player.connect("player_dead", Callable(self, "game_over"))
		player.connect("hp_change", Callable(self, "update_hp"))
		player.connect("shield_change", Callable(self, "update_shield"))
		skill1.connect("trigger_skill", Callable(player, "fire_weapon1"))
		skill2.connect("trigger_skill", Callable(player, "fire_weapon2"))
		skill3.connect("trigger_skill", Callable(player, "fire_weapon3"))


func end_mission():
	clear_screen()
	self.state = GameState.OUTRO


func update_hp(val):
	$UI/HUD/Content/Hull/BarHP.value = val


func update_shield(val):
	$UI/HUD/Content/Shield/BarShield.value = val


func update_score(val):
	score += val
	$UI/HUD/Content/Payout.text = "PAYOUT: %d CR" % score


func game_over():
	$SpawnTimer.stop()
	clear_screen()
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
	if wave_count >= active_mission.waves.size():
		if is_scrolling:
			is_scrolling = false
			$AnimationPlayer.play("warning_flash")
			$SpawnTimer.start(BOSS_WAIT)
		elif !boss_spawned:
			print("Boss time!")
			$AnimationPlayer.play("RESET")
			var boss_inst
			boss_inst = active_mission.boss.instantiate()
			add_child(boss_inst)
			boss_inst.connect("enemy_dead", Callable(self, "update_score"))
			boss_inst.connect("boss_dead", Callable(self, "end_mission"))
			boss_inst.global_position.x = 0.5 * screen_size.x
			boss_inst.global_position.y = 0.2 * screen_size.y
			boss_inst.move_pattern.set_script(load("res://data/MoveFigureEight.gd"))
			boss_spawned = true
			$SpawnTimer.stop()
	else:
		print("Time: %d, Enemy wave: %d" % [time_count, wave_count])
		var this_wave = active_mission.waves[wave_count]
		for i in this_wave.size:
			for pos in this_wave.spawn.pattern:
				var enemy_inst = enemy_obj.instantiate()
				add_child(enemy_inst)
				enemy_inst.connect("enemy_dead", Callable(self, "update_score"))
				enemy_inst.global_position.x = (pos.position.x * PLAY_AREA.size.x)
				enemy_inst.global_position.y = (pos.position.y * PLAY_AREA.size.y)
				enemy_inst.global_position += PLAY_AREA.position
				enemy_inst.move_pattern.set_script(load("res://data/%s.gd" % pos.move))
				enemy_inst.move_pattern.speed = pos.speed
				enemy_inst.move_pattern.time_scale = pos.time_scale
				enemy_inst.move_pattern.flip_h = pos.flip_h
				await get_tree().create_timer(pos.delay).timeout
				if state != GameState.PLAY:
					return
			await get_tree().create_timer(this_wave.spawn.repeat_delay).timeout
			if state != GameState.PLAY:
				return
		wave_count += 1
		$SpawnTimer.start(this_wave.next)


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

