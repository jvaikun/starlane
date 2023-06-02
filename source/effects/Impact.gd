extends AnimatedSprite

func _on_Impact_animation_finished():
	queue_free()
