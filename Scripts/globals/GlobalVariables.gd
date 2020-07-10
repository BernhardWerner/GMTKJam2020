extends Node


var living_space : Rect2

func _ready() -> void:
	randomize()
	living_space.position = Vector2.ZERO
	living_space.size = OS.window_size
