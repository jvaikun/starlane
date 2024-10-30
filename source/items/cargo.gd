extends Area2D

const MOVE_SPEED = 80
const FOLLOW_DIST = 64
const explode_obj = preload("res://effects/explosion.tscn")
const impact_obj = preload("res://effects/impact.tscn")

var hp : int = 100 : set = set_hp
var is_grabbed : bool = false
var price = 500
var move_dir : Vector2 = Vector2.DOWN
var player_node : Area2D = null


func set_hp(value : int):
	hp = value
	price = hp * 5
	$Label.text = str(price)
	if hp <= 0:
		var explode_inst = explode_obj.instantiate()
		get_parent().add_child(explode_inst)
		explode_inst.global_position = global_position
		queue_free()


func _process(delta):
	if is_grabbed:
		if self.global_position.distance_to(player_node.global_position) > FOLLOW_DIST:
			move_dir = player_node.global_position - self.global_position
		else:
			move_dir = Vector2.ZERO
	else:
		move_dir = Vector2.DOWN
	translate(MOVE_SPEED * move_dir.normalized() * delta)


func set_grab(state : bool, player : Area2D = null):
	is_grabbed = state
	player_node = player


func _on_area_entered(area):
	if area.is_in_group("bullet"):
		hp -= area.dmg
		var impact_inst = impact_obj.instantiate()
		get_parent().add_child(impact_inst)
		impact_inst.global_position = area.global_position
		area.queue_free()


func _on_vis_check_screen_exited():
	if !is_queued_for_deletion():
		queue_free()

