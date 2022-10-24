extends TextureButton

export var cooldown_time = 1.0
export var hotkey = "Z"

signal trigger_skill

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cooldown.wait_time = cooldown_time
	$Sweep.texture_progress = texture_normal
	$Sweep.value = 0
	$Label.text = hotkey
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Sweep.value = int(($Cooldown.time_left / cooldown_time) * 100)


func fire_skill():
	if !disabled:
		disabled = true
		emit_signal("trigger_skill")
		set_process(true)
		$Cooldown.start()


func _on_SkillButton_pressed():
	fire_skill()


func _on_Cooldown_timeout():
	$Sweep.value = 0
	disabled = false
	set_process(false)
