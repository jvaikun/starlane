extends Area2D

const bullet_obj = preload("res://bullets/BulletPlayer.tscn")
const missile_obj = preload("res://bullets/Missile.tscn")
const MAX_HP = 50.0
const MAX_SHIELD = 10.0
const WEAPON_TIME1 = 2.0
const WEAPON_TIME2 = 5.0
const WEAPON_TIME3 = 5.0

var hp = 50.0 setget set_hp
var shield = 10.0 setget set_shield
var regen_on = false
var beam_firing = false
var defense_on = false

signal player_dead
signal hp_change
signal shield_change

func set_hp(value):
	hp = clamp(value, 0, MAX_HP)
	if hp == 0:
		emit_signal("player_dead")
		queue_free()
	else:
		emit_signal("hp_change", float(hp/MAX_HP))


func set_shield(value):
	var overflow = 0
	if value < 0:
		shield = 0
		self.hp += value
	else:
		shield = clamp(value, 0, MAX_SHIELD)
	if shield == MAX_SHIELD:
		regen_on = false
	emit_signal("shield_change", float(shield/MAX_SHIELD))


# Called when the node enters the scene tree for the first time.
func _ready():
	$ShootTimer1.start(0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if regen_on:
		self.shield += 5 * delta


# Main gun, big fucking bullet, screen clear
func fire_weapon1():
	var targets = $Beam.get_overlapping_areas()
	for target in targets:
		if target.is_in_group("enemies"):
			target.hp -= 100
		elif target.is_in_group("bullet_enemy"):
			target.queue_free()
	$SpecialTimer.start(WEAPON_TIME1)
	$Beam/Sprite.show()
	beam_firing = true


# Missile barrage, massive salvos of tracking missiles
func fire_weapon2():
	$ShootTimer2.start(0.1)
	$SpecialTimer.start(WEAPON_TIME2)


# Ultra shield, absorbs bullets and inflicts damage
func fire_weapon3():
	var targets = $Radius.get_overlapping_areas()
	for target in targets:
		if target.is_in_group("bullet_enemy"):
			target.queue_free()
	$SpecialTimer.start(WEAPON_TIME3)
	$Radius/Sprite.show()
	defense_on = true


func _on_ShootTimer1_timeout():
	var bullet
	for pos in [$FirePos1, $FirePos2, $FirePos3]:
		bullet = bullet_obj.instance()
		get_parent().add_child(bullet)
		bullet.global_position = pos.global_position
		bullet.velocity = Vector2(0, -256)


func _on_ShootTimer2_timeout():
	var missile1 = missile_obj.instance()
	get_parent().add_child(missile1)
	missile1.global_position = $FirePos2.global_position
	missile1.velocity = Vector2(-64, -256)
	var missile2 = missile_obj.instance()
	get_parent().add_child(missile2)
	missile2.global_position = $FirePos2.global_position
	missile2.velocity = Vector2(-32, -256)
	var missile3 = missile_obj.instance()
	get_parent().add_child(missile3)
	missile3.global_position = $FirePos3.global_position
	missile3.velocity = Vector2(32, -256)
	var missile4 = missile_obj.instance()
	get_parent().add_child(missile4)
	missile4.global_position = $FirePos3.global_position
	missile4.velocity = Vector2(64, -256)


func _on_Player_area_entered(area):
	if area.is_in_group("bullet_enemy"):
		regen_on = false
		$ShieldRegen.start()
		self.shield -= area.dmg
		area.queue_free()


func _on_ShieldRegen_timeout():
	regen_on = true


func _on_SpecialTimer_timeout():
	beam_firing = false
	$Beam/Sprite.hide()
	$ShootTimer2.stop()
	defense_on = false
	$Radius/Sprite.hide()


func _on_Radius_area_entered(area):
	if defense_on and area.is_in_group("bullet_enemy"):
		area.queue_free()


func _on_Beam_area_entered(area):
	if beam_firing:
		if area.is_in_group("enemies"):
			area.hp -= 100
		elif area.is_in_group("bullet_enemy"):
			area.queue_free()
