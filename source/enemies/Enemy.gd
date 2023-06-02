class_name Enemy
extends Node2D

const explode_obj = preload("res://effects/Explosion.tscn")
const impact_obj = preload("res://effects/Impact.tscn")

var hp = 1 setget set_hp
var score_value = 5
var direction = Vector2.DOWN
var speed = 0
var origin = 0
var time = 0.0
var time_scale = 1.0
var shot_pattern = []
var shot_time = 1.0
var move_pattern

signal enemy_dead

func set_hp(value):
	hp = value
	if hp <= 0:
		emit_signal("enemy_dead", score_value)
		var explode_inst = explode_obj.instance()
		get_parent().add_child(explode_inst)
		explode_inst.global_position = global_position
		queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
	$ShootTimer.start(shot_time)
	move_pattern = Resource.new()
	move_pattern.set_script(load("res://data/MoveDown.gd"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(move_pattern.get_velocity(delta) * delta)


func shoot():
	var bullet_inst
	for shot in shot_pattern:
		bullet_inst = shot.bullet.instance()
		get_parent().add_child(bullet_inst)
		bullet_inst.global_position = shot.pos.global_position
		bullet_inst.velocity = shot.velocity


func _on_VisCheck_screen_exited():
	if !is_queued_for_deletion():
		queue_free()


func _on_Enemy_area_entered(area):
	if area.is_in_group("bullet_player"):
		self.hp -= area.dmg
		var impact_inst = impact_obj.instance()
		get_parent().add_child(impact_inst)
		impact_inst.global_position = area.global_position
		area.queue_free()


func _on_ShootTimer_timeout():
	$ShootTimer.start(shot_time)
	shoot()
