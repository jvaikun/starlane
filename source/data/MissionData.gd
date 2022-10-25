extends Resource
class_name MissionData

export (String) var title = "Mission 1"
export (String) var subtitle = "Chain of Command"
var intro = []
var waves = []
var outro = []
export (PackedScene) var boss = load("res://bosses/EnemyBoss.tscn")
