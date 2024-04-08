# Array of EnemyData resources, used for spawning waves of enemies
extends Resource
class_name EnemyWave

@export var spawn_time : float = 0.0
@export var enemies : Array = []

