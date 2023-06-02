extends Resource

var time = 0.0
var time_scale = TAU
var speed = 100.0
var flip_h = false
var current_dir = 0
var reverse = 1

func get_velocity(delta):
	time += delta
	if time >= time_scale:
		time = 0.0
		reverse = -reverse
	var velocity = Vector2.ZERO
	velocity.x = sin(time) * reverse
	velocity.y = cos(time)
	if flip_h:
		velocity.x = -velocity.x
	return velocity.normalized() * speed
