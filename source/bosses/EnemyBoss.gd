extends "res://enemies/Enemy.gd"

var scn_bullet = preload("res://bullets/BulletEnemy.tscn")
var path = []
var destination = 0

signal boss_dead

func set_hp(value):
	hp = value
	if hp <= 0:
		emit_signal("enemy_dead", score_value)
		emit_signal("boss_dead")
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	score_value = 500
	destination = 0
	$ShootTimer.connect("timeout", self, "shoot")
	$ShootTimer.one_shot = false
	$ShootTimer.start(0.2)
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

func shoot():
	if is_processing():
		$ShootTimer.start()
		var bullet1 = create_bullet($FirePos1.global_position)
		bullet1.velocity = Vector2(-150, 200)
		var bullet2 = create_bullet($FirePos1.global_position)
		bullet2.velocity = Vector2(-100, 200)
		var bullet3 = create_bullet($FirePos1.global_position)
		bullet3.velocity = Vector2(100, 200)
		var bullet4 = create_bullet($FirePos1.global_position)
		bullet4.velocity = Vector2(150, 200)

func create_bullet(pos):
	var bullet = scn_bullet.instance()
	bullet.position = pos
	get_parent().add_child(bullet)
	return bullet
