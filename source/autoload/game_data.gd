extends Node

var mission_gen = MissionGen.new()
var mission_waves : Array[Dictionary]
var mission_data : Mission


func build_mission():
	mission_data = mission_gen.generate_mission(mission_waves)

