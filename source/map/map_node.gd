extends Button

enum SelfState {INACTIVE, ACTIVE, SELECTED, LOCKED}

const INFO_TEXT = "Type: %s\nHazard: %s"

var state = SelfState.INACTIVE : set = set_state

# Link list item: {node, line}
var id : String = ""
var type : String = "assault"
var desc : String = "Assault"
var data : Dictionary = {
	"loot_level" : 1,
	"loot_multiplier" : 1,
	"loot_value" : 0,
	"enemy_level" : 1,
	"enemy_multiplier" : 1,
	"enemy_amount" : 1,
	"hazard_level" : 1,
	"hazard_type" : "none",
}
var coords : Vector2 = Vector2.ZERO
var lines : Array = []
var node_next : Array = []
var node_prev : Array = []

signal node_hovered(info_text)
signal node_clicked(this_node)


func set_state(val):
	state = val
	match state:
		SelfState.INACTIVE:
			modulate = Color.DIM_GRAY
			disabled = true
		SelfState.ACTIVE:
			modulate = Color.WHITE
			disabled = false
			for next in node_next:
				next.state = SelfState.INACTIVE
			for line in lines:
				line.line.default_color = Color.WHITE
				line.line.width = 2.0
			for prev in node_prev:
				if prev.state == SelfState.LOCKED:
					prev.state = SelfState.SELECTED
		SelfState.SELECTED:
			modulate = Color.DODGER_BLUE
			disabled = false
			for next in node_next:
				next.state = SelfState.ACTIVE
			for line in lines:
				line.line.width = 3.0
				line.line.default_color = Color.CYAN
			for prev in node_prev:
				if prev.state == SelfState.SELECTED:
					prev.state = SelfState.LOCKED
		SelfState.LOCKED:
			disabled = true
			for next in node_next:
				if next.state == SelfState.SELECTED:
					for line in lines:
						if line.node == next:
							line.line.default_color = Color.BLUE
						else:
							line.line.default_color = Color.WHITE
							line.line.width = 2.0
				else:
					next.state = SelfState.INACTIVE


func add_next(node):
	for next in node_next:
		if node == next:
			return
	node_next.append(node)


func add_prev(node):
	for prev in node_prev:
		if node == prev:
			return
	node_prev.append(node)


func clear_nodes():
	set_state(SelfState.INACTIVE)
	lines.clear()
	node_next.clear()
	node_prev.clear()


func _on_mouse_entered():
	node_hovered.emit(INFO_TEXT % [type, data.hazard_type])


func _on_pressed():
	if button_pressed:
		set_state(SelfState.SELECTED)
	else:
		set_state(SelfState.ACTIVE)
	node_clicked.emit(self)

