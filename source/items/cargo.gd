extends Area2D

const MOVE_SPEED = 160
const explode_obj = preload("res://effects/explosion.tscn")

var hp : int = 10 : set = set_hp
var move_dir : Vector2 = Vector2.DOWN


func set_hp(value):
	if hp <= 0:
		var explode_inst = explode_obj.instantiate()
		get_parent().add_child(explode_inst)
		explode_inst.global_position = global_position
		queue_free()


func _process(delta):
	translate(MOVE_SPEED * move_dir.normalized() * delta)

