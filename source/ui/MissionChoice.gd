extends VBoxContainer

onready var tiles = [
	$Body/List/MissionTile,
	$Body/List/MissionTile2,
	$Body/List/MissionTile3,
]

signal mission_choice(num)

func update_ui(missions):
	for i in tiles.size():
		tiles[i].update_ui(missions[i].name, missions[i].map, missions[i].hazard)


func _on_MissionTile_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			emit_signal("mission_choice", 0)


func _on_MissionTile2_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			emit_signal("mission_choice", 1)


func _on_MissionTile3_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			emit_signal("mission_choice", 2)
