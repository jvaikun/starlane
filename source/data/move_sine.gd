extends Resource

var time = 0.0
var time_scale = TAU
var speed = 150.0
var flip_h = false

func get_velocity(delta):
	time += delta * 2
	if time >= time_scale:
		time = 0.0
	var velocity = Vector2(sin(time), 1).normalized() * speed
	if flip_h:
		velocity.x = -velocity.x
	return velocity
