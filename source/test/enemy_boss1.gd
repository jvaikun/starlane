extends Enemy

var bullet_obj = preload("res://bullets/bullet_enemy.tscn")
var path = []
var destination = 0
@onready var parts = {
	"core":{"hp":30, "area":$Core, "sprite":$Core/Sprite, "dead":false},
	"left":{"hp":25, "area":$Core/Left, "sprite":$Core/Sprite, "dead":false},
	"right":{"hp":25, "area":$Core/Right, "sprite":$Core/Sprite, "dead":false},
	"frontl":{"hp":30, "area":$Core/FrontL, "sprite":$Core/Sprite, "dead":false},
	"frontr":{"hp":30, "area":$Core/FrontR, "sprite":$Core/Sprite, "dead":false},
}

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
	hp = 24
	speed = 150
	path = [
		Vector2(64, 64),
		Vector2(get_viewport_rect().size.x - 64, 64)
	]
	$Core.area_entered.connect(_on_hit_handler.bind("core"))
	$Core/Left.area_entered.connect(_on_hit_handler.bind("left"))
	$Core/Right.area_entered.connect(_on_hit_handler.bind("right"))
	$Core/FrontL.area_entered.connect(_on_hit_handler.bind("frontl"))
	$Core/FrontR.area_entered.connect(_on_hit_handler.bind("frontr"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.global_position.distance_to(path[destination]) < 4:
		destination += 1
		if destination >= path.size():
			destination = 0
	else:
		direction = (path[destination] - self.global_position)


func _on_hit_handler(area, index):
	if !(index in parts.keys()) or parts[index].dead:
		return
	elif area.is_in_group("bullet_player"):
		parts[index].hp -= 1
		area.queue_free()
		parts[index].dead = (parts[index].hp <= 0)
		parts[index].area.visible = !parts[index].dead

