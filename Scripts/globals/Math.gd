extends Node
class_name Math

static func rand_dir() -> Vector2:
	var angle = 2 * PI * randf()
	return Vector2(sin(angle), cos(angle))

static func rand_pos() -> Vector2:
	return GlobalVariables.living_space.position + Vector2(randf() * GlobalVariables.living_space.size.x, randf() * GlobalVariables.living_space.size.y)
	
