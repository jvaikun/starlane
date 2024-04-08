extends Control

enum SelfState {INACTIVE, ACTIVE, SELECTED}

const INFO_TEXT = "Type: %s\nWaves: %d\nHazards: %s"
const OFFSET = Vector2.ONE * 16

@onready var button = $Button
@onready var lines = $Lines

var state = SelfState.INACTIVE : set = set_state

# Link list item: {node, line}
var link_list : Array = []
var type : String = "Assault"
var waves : int = 3
var hazards : Array = ["Asteroids", "Bombardment"]
var coords : Vector2 = Vector2.ZERO

signal node_hovered(info_text)


func set_state(val):
	state = val
	match state:
		SelfState.INACTIVE:
			modulate = Color.DIM_GRAY
		SelfState.ACTIVE:
			modulate = Color.WHITE
		SelfState.SELECTED:
			modulate = Color.DODGER_BLUE
			highlight(true)


func add_node(new_node):
	for link in link_list:
		if new_node == link.node:
			return
	var new_line = Line2D.new()
	lines.add_child(new_line)
	link_list.append({"node":new_node, "line":new_line})
	new_line.default_color = Color.WHITE
	new_line.width = 2.0
	new_line.clear_points()
	new_line.add_point(OFFSET)
	new_line.add_point(new_node.global_position - global_position + OFFSET)


func clear_nodes():
	set_state(SelfState.INACTIVE)
	for line in lines.get_children():
		line.free()
	link_list.clear()


func highlight(toggle):
	for link in link_list:
		if toggle:
			if link.node.clicked:
				link.line.default_color = Color.BLUE
				link.line.width = 3.0
		elif (state == SelfState.SELECTED) and (link.node.state == SelfState.SELECTED):
			link.line.default_color = Color.BLUE
			link.line.width = 3.0
		else:
			link.line.default_color = Color.WHITE
			link.line.width = 2.0


func _on_mouse_entered():
	node_hovered.emit(INFO_TEXT % [type, waves, ", ".join(hazards)])
	if (state == SelfState.ACTIVE):
		highlight(true)


func _on_mouse_exited():
	highlight(false)


func _on_button_pressed():
	#print("Links: " + str(next_nodes))
	set_state(SelfState.SELECTED)

