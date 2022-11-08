# Spawn information for a single enemy within an EnemyWave
extends Resource
class_name EnemyData

# Scene to spawn
export (PackedScene) var scene

# Initial direction
export (Vector2) var direction = Vector2.DOWN

# Initial position, as percentage of screen width (X) and height (Y)
export (Vector2) var start_position
