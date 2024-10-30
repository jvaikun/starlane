extends Control

const MAP_POS = Vector2(128,160)
const MAP_SPACING = 64
const OFFSET = Vector2.ONE * 16
const HAZARDS = {
	"asteroid":"Asteroid Field",
	"meteor":"Meteor Shower",
	"mines":"Minefield",
}
const NODE_TYPES = {
	"assault":{"icon":"res://map/textures/icon_battle.png", "desc":"Assault"},
	"rush":{"icon":"res://map/textures/icon_rush.png", "desc":"Blitz"},
	"salvage":{"icon":"res://map/textures/icon_salvage.png", "desc":"Salvage"},
	"station":{"icon":"res://map/textures/icon_station.png", "desc":"Station"},
}
const map_node_obj = preload("res://map/map_node.tscn")
const PATH_COUNT = 4
const ROW_SIZE = 6
const COL_SIZE = 8

@onready var wave_labels = $Route/Content/Waves.get_children()
@onready var wave_info = $Route/Content/WaveInfo

var graph_data : Array = []
var path_data : Array = []
var active_nodes : Array = []
var selected_nodes : Array = []

signal mission_confirmed


func _ready():
	# Prep labels
	wave_info.text = ""
	for label in wave_labels:
		label.text = "No wave selected"
	# Generate grid
	for i in COL_SIZE:
		var graph_row = []
		for j in ROW_SIZE:
			var map_node_inst = map_node_obj.instantiate()
			add_child(map_node_inst)
			map_node_inst.state = map_node_inst.SelfState.INACTIVE
			map_node_inst.id = "_".join([str(j), str(i)])
			map_node_inst.node_hovered.connect(update_info)
			map_node_inst.node_clicked.connect(_on_node_clicked)
			map_node_inst.position.x = MAP_POS.x + (j * MAP_SPACING)
			map_node_inst.position.y = size.y - MAP_POS.y - (i * MAP_SPACING)
			map_node_inst.coords = Vector2(j, i)
			graph_row.append(map_node_inst)
		graph_data.append(graph_row)


func reset_map():
	wave_info.text = ""
	for label in wave_labels:
		label.text = "No wave selected"
	path_data.clear()
	for node in active_nodes:
		node.clear_nodes()
	for line in $Lines.get_children():
		line.queue_free()
	active_nodes.clear()


# TODO: Cleaner, more efficient graph generation?
func gen_paths():
	reset_map()
	# Pick starting points for paths
	var start_pool = range(ROW_SIZE)
	start_pool.shuffle()
	var start_points = start_pool.slice(0, ROW_SIZE/2)
	for i in PATH_COUNT - start_points.size():
		start_points.append(start_pool.pick_random())
	# Generate paths
	var pool = []
	var prev_col = 0
	for point in start_points:
		var path = []
		for j in COL_SIZE:
			if path.is_empty():
				path.append(point)
			else:
				pool.clear()
				prev_col = path.back()
				if prev_col == 0:
					pool = [0, prev_col+1]
				elif prev_col == ROW_SIZE-1:
					pool = [prev_col-1, prev_col]
				else:
					pool = [prev_col-1, prev_col, prev_col+1]
				for other_path in path_data:
					if other_path[j] == prev_col and other_path[j-1] != prev_col:
						pool.erase(other_path[j-1])
				path.append(pool.pick_random())
		path_data.append(path)
	# Link up nodes in paths
	for i in path_data.size():
		for j in path_data[i].size():
			var this_node = graph_data[j][path_data[i][j]]
			if j == 0:
				this_node.add_next(graph_data[j+1][path_data[i][j+1]])
			elif j == path_data[i].size()-1:
				this_node.add_prev(graph_data[j-1][path_data[i][j-1]])
			else:
				this_node.add_next(graph_data[j+1][path_data[i][j+1]])
				this_node.add_prev(graph_data[j-1][path_data[i][j-1]])
			active_nodes.append(this_node)
	# Build lines for paths
	for node in active_nodes:
		for next in node.node_next:
			var new_line = Line2D.new()
			$Lines.add_child(new_line)
			new_line.clear_points()
			new_line.add_point(node.global_position + OFFSET)
			new_line.add_point(next.global_position + OFFSET)
			new_line.width = 2.0
			new_line.default_color = Color.WHITE
			node.lines.append({"line":new_line, "node":next})
	# Assign level types to nodes and hide unused nodes
	# Types: Battle, Rush, Scavenging, Trader, Station
	for i in COL_SIZE:
		for j in ROW_SIZE:
			if !(graph_data[i][j] in active_nodes):
				graph_data[i][j].hide()
				pass
			else:
				var type = NODE_TYPES.keys().pick_random()
				graph_data[i][j].type = type
				graph_data[i][j].desc = NODE_TYPES[type].desc
				graph_data[i][j].icon = load(NODE_TYPES[type].icon)
				graph_data[i][j].show()
	for node in graph_data[0]:
		node.state = node.SelfState.ACTIVE


func update_info(info_text):
	wave_info.text = info_text


func _on_node_clicked(node):
	var node_row = node.coords.y
	if node.state == node.SelfState.SELECTED:
		selected_nodes.append(node)
		wave_labels[node_row].text = "Wave %d: %s, %s" % [node_row+1, node.type, node.id]
		if node in graph_data[0]:
			for start_point in graph_data[0]:
				if start_point != node:
					start_point.state = start_point.SelfState.INACTIVE
	else:
		selected_nodes.erase(node)
		wave_labels[node_row].text = "No wave selected"
		if node in graph_data[0]:
			for start_point in graph_data[0]:
				start_point.state = start_point.SelfState.ACTIVE


func _on_btn_reroll_pressed():
	gen_paths()


func _on_btn_run_pressed():
	GameData.mission_waves.clear()
	for node in selected_nodes:
		if node.state == node.SelfState.LOCKED or node.state == node.SelfState.SELECTED:
			GameData.mission_waves.append(node)
	GameData.build_mission()
	mission_confirmed.emit()


func _on_btn_equip_pressed():
	pass # Replace with function body.


func _on_btn_quit_pressed():
	pass # Replace with function body.

