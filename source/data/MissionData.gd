extends Resource
class_name MissionData

export (String) var title = "Mission 1"
export (String) var subtitle = "Chain of Command"
var intro = []
export var waves = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
var outro = []
export (PackedScene) var boss = load("res://bosses/EnemyBoss.tscn")
