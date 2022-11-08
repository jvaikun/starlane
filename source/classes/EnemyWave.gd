# Array of EnemyData resources, used for spawning waves of enemies
extends Resource
class_name EnemyWave

export (float) var spawn_time = 0.0
export (Array, Resource) var enemies

