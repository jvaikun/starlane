extends Area2D

const MOVE_SPEED = 160
const impact_obj = preload("res://effects/impact.tscn")
const explode_obj = preload("res://effects/explosion.tscn")
const TYPES = {
	"square_sm":"res://hazards/textures/asteroid_8x8.png",
	"square_md":"res://hazards/textures/asteroid_16x16.png",
	"square_lg":"res://hazards/textures/asteroid_32x32.png",
	"square_xl":"res://hazards/textures/asteroid_48x48.png",
	"rect_sm":"res://hazards/textures/asteroid_8x16.png",
	"rect_md":"res://hazards/textures/asteroid_16x24.png",
	"rect_lg":"res://hazards/textures/asteroid_24x32.png",
	"rect_xl":"res://hazards/textures/asteroid_32x48.png",
}

var type : String = "square_small" : set = set_type
var hp : int = 10 : set = set_hp
var move_dir : Vector2 = Vector2.DOWN


func set_hp(value):
	hp = value
	if hp <= 0:
		var explode_inst = explode_obj.instantiate()
		get_parent().add_child(explode_inst)
		explode_inst.global_position = global_position
		queue_free()


func set_type(val : String):
	if val in TYPES.keys():
		type = val
		$Sprite.texture = load(TYPES[type])
		$Collision.shape.size = $Sprite.texture.get_size()


func _ready():
	set_type(TYPES.keys().pick_random())


func _process(delta):
	translate(MOVE_SPEED * move_dir.normalized() * delta)


func _on_area_entered(area):
	if area.is_in_group("bullet_player"):
		hp -= area.dmg
		var impact_inst = impact_obj.instantiate()
		get_parent().add_child(impact_inst)
		impact_inst.global_position = area.global_position
		area.queue_free()


func _on_vis_check_screen_exited():
	if !is_queued_for_deletion():
		queue_free()

