extends Resource
class_name Mission


var name : String = "Mission Name"
var background : String = ""
var map_points : Array[Vector2] = []
var loot_level : int = 1
var loot_multiplier : int = 1
var loot_value : int = 0
var enemy_level : int = 1
var enemy_multiplier : int = 1
var enemy_amount : int = 1
var hazard_level : int = 1
var hazards : Array[String] = []
var waves : Array = []
var boss : PackedScene

