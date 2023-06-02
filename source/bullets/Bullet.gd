extends Area2D

var velocity = Vector2()
var dmg = 1


func _process(delta):
	translate(velocity * delta)


func _on_VisCheck_screen_exited():
	if !is_queued_for_deletion():
		queue_free()
