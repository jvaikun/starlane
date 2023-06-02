extends Resource

var time = 0.0
var time_scale = 1.0
var speed = 150.0
var flip_h = false

func get_velocity(delta):
	time += delta
	if time >= time_scale:
		time = 0.0
	var velocity = Vector2.DOWN * speed
	return velocity
