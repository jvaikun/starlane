extends "res://enemies/Enemy.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	score_value = 10
	velocity.y = 300
	hp = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
