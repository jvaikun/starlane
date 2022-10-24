extends Control

enum GameState {TITLE, PLAY, PAUSE, END}

const data_path = "res://data/Mission%d.tres"
const spawn_list = [
	preload("res://enemies/EnemyDrone.tscn"), 
	preload("res://enemies/EnemyGunner.tscn"), 
	preload("res://enemies/EnemyHeavy.tscn"), 
	preload("res://enemies/EnemyStriker.tscn")
]
const player_obj = preload("res://player/Player.tscn")

onready var skill1 = $HUDRight/SkillButton
onready var skill2 = $HUDRight/SkillButton2
onready var skill3 = $HUDRight/SkillButton3

var player = null
var state = GameState.TITLE setget set_state
var level_index = 1
var current_level = load(data_path % level_index)
var score = 0
var dir_vector = Vector2.ZERO
var wave_count = 0
var boss_active = false

func set_state(value):
	if value in GameState.values():
		state = value
		match state:
			GameState.TITLE:
				$MainMenu.show()
				$HUDLeft.hide()
				$HUDRight.hide()
				$GameOver.hide()
			GameState.PLAY:
				current_level = load(data_path % level_index)
				print(current_level.title)
				$MainMenu.hide()
				$GameOver.hide()
				score = 0
				update_score(0)
				update_hp(1)
				update_shield(1)
				$HUDLeft.show()
				$HUDRight.show()
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
				$SpawnTimer.start()
			GameState.PAUSE:
				pass
			GameState.END:
				player.queue_free()
				$HUDLeft.hide()
				$HUDRight.hide()
				$GameOver.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.state = GameState.TITLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		GameState.PLAY:
			if !boss_active:
				$ParallaxBackground/ParallaxLayer.motion_offset.y += 128 * delta
			if is_instance_valid(player):
				dir_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
				dir_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
				player.translate(dir_vector.normalized() * 4)
			if Input.is_action_just_pressed("ui_weapon1"):
				skill1.fire_skill()
			if Input.is_action_just_pressed("ui_weapon2"):
				skill2.fire_skill()
			if Input.is_action_just_pressed("ui_weapon3"):
				skill3.fire_skill()


func end_level():
	level_index = clamp(level_index + 1, 1, 12)
	current_level = load(data_path % level_index)
	boss_active = false
	wave_count = 0
	$SpawnTimer.start()


func update_hp(val):
	$HUDLeft/BarHP.value = val * 100


func update_shield(val):
	$HUDLeft/BarShield.value = val * 100


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
	self.state = GameState.PLAY


func _on_BtnInstructions_pressed():
	pass # Replace with function body.


func _on_BtnCredits_pressed():
	pass # Replace with function body.


func _on_BtnRestart_pressed():
	self.state = GameState.PLAY


func _on_BtnQuit_pressed():
	self.state = GameState.TITLE


func _on_SpawnTimer_timeout():
	var enemy_inst
	if wave_count >= 10:
		if !boss_active:
			print("Boss time!")
			enemy_inst = current_level.boss.instance()
			add_child(enemy_inst)
			enemy_inst.connect("enemy_dead", self, "update_score")
			enemy_inst.connect("boss_dead", self, "end_level")
			enemy_inst.global_position = Vector2(256, 64)
			boss_active = true
			$SpawnTimer.stop()
	else:
		print("Enemy wave: %d" % wave_count)
		for i in 4:
			enemy_inst = spawn_list[randi() % spawn_list.size()].instance()
			add_child(enemy_inst)
			enemy_inst.connect("enemy_dead", self, "update_score")
			enemy_inst.global_position = Vector2(128 + i*96, -32)
		wave_count += 1
