extends Node2D

var hp = 1 setget set_hp
var score_value = 5
var velocity = Vector2(0, 0)
var origin = 0

signal enemy_dead

func set_hp(value):
	hp = value
	if hp <= 0:
		emit_signal("enemy_dead", score_value)
		queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(velocity * delta)


func _on_VisCheck_screen_exited():
	if !is_queued_for_deletion():
		queue_free()


func _on_Enemy_area_entered(area):
	if area.is_in_group("bullet_player"):
		self.hp -= area.dmg
		area.queue_free()
