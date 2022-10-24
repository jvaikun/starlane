extends Area2D

var velocity = Vector2()
var dmg = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	translate(velocity * delta)

func _on_BulletPlayer_area_entered(area):
	if area.is_in_group("bullet_enemy"):
		area.queue_free()
		queue_free()

func _on_VisCheck_screen_exited():
	if !is_queued_for_deletion():
		queue_free()
