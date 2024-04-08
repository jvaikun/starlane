extends Control

const MAPS = ["starfield1", "starfield2", "nebula1", "nebula2"]
const HAZARDS = {
	"asteroid":"Asteroid Field",
	"meteor":"Meteor Shower",
	"mines":"Minefield",
}
const NODE_TYPES = {
	"battle":{"icon":"res://map/textures/icon_battle.png"},
	"rush":{"icon":"res://map/textures/icon_rush.png"},
	"salvage":{"icon":"res://map/textures/icon_salvage.png"},
	"station":{"icon":"res://map/textures/icon_station.png"},
	"trader":{"icon":"res://map/textures/icon_trader.png"},
}
const map_node_obj = preload("res://map/map_node.tscn")
const ROW_SIZE = 6
const COL_SIZE = 10

var mission_gen = MissionGen.new()
var mission_info : String = ""
var mission_data : Mission

var current_row = 0
var graph_data : Array = []
var path_data : Array = []
var active_nodes : Array = []
var selected_nodes : Array = []


func _ready():
	# Generate graph
	for i in COL_SIZE:
		var graph_row = []
		for j in ROW_SIZE:
			var map_node_inst = map_node_obj.instantiate()
			add_child(map_node_inst)
			map_node_inst.node_hovered.connect(update_info)
			map_node_inst.position.x = 128 + (j * 64)
			map_node_inst.position.y = size.y - 96 - (i * 64)
			map_node_inst.coords = Vector2(j, i)
			graph_row.append(map_node_inst)
		graph_data.append(graph_row)


func reset_map():
	current_row = 0
	path_data.clear()
	for node in active_nodes:
		node.clear_nodes()
	active_nodes.clear()


func gen_paths():
	reset_map()
	# Pick starting points for paths
	var pick_rand = []
	for i in ROW_SIZE:
		pick_rand.append(i)
	var start_points = []
	pick_rand.shuffle()
	start_points.append(pick_rand[0])
	start_points.append(pick_rand[1])
	pick_rand.shuffle()
	for i in ROW_SIZE-2:
		start_points.append(pick_rand[i])
	# Generate paths
	var pool = []
	var prev_col = 0
	for i in start_points:
		var path = []
		for j in COL_SIZE:
			if path.is_empty():
				path.append(start_points[i])
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
	# Create lines for paths by linking nodes
	for i in path_data.size():
		for j in path_data[i].size():
			var this_node = graph_data[j][path_data[i][j]]
			if j != 0:
				this_node.add_node(graph_data[j-1][path_data[i][j-1]])
				pass
			active_nodes.append(this_node)
	# Assign level types to nodes and hide unused nodes
	# Types: Battle, Rush, Scavenging, Trader, Station
	for i in COL_SIZE:
		for j in ROW_SIZE:
			if !(graph_data[i][j] in active_nodes):
				graph_data[i][j].hide()
			else:
				var type = "station"
				if i != COL_SIZE-1:
					type = NODE_TYPES.keys().pick_random()
				graph_data[i][j].button.icon = load(NODE_TYPES[type].icon)
				graph_data[i][j].waves = 3 + randi() % 4
				graph_data[i][j].show()
	for node in graph_data[current_row]:
		print(node.waves)
		node.state = node.SelfState.ACTIVE


func update_info(info_text):
	mission_info = info_text


func _on_btn_reroll_pressed():
	gen_paths()


func _on_btn_run_pressed():
	var phases = []
	for node in active_nodes:
		if node.clicked:
			phases.append({
				"type":node.type,
				"waves":node.waves,
				"hazards":node.hazards,
				"coords":node.coords,
			})
	mission_data = mission_gen.generate_mission(phases)

