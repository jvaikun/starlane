extends Resource

var time = 0.0
var time_scale = 2.0
var speed = 150.0
var flip_h = false

func get_velocity(delta):
	time += delta
	if time >= time_scale:
		time = 0.0
	var velocity = Vector2.ZERO
	if (time < time_scale * 0.5):
		velocity = Vector2(1, 0.5).normalized() * speed
	else:
		velocity = Vector2(-1, 0.5).normalized() * speed
	if flip_h:
		velocity.x = -velocity.x
	return velocity
