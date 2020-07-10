extends KinematicBody2D

var tribe : int
var dir : Vector2
var speed : float

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################

func setup() -> void:
	tribe = round(randf())
	$Sprite.modulate = Tribes.colors[tribe]
	speed = Tribes.speeds[tribe]
	var angle = 2 * PI * randf()
	dir = Vector2(sin(angle), cos(angle))
	global_position = GlobalVariables.living_space.position + Vector2(randf() * GlobalVariables.living_space.size.x, randf() * GlobalVariables.living_space.size.y)
	

######################### BUILT-INS #########################

func _ready() -> void:
	setup()

func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(dir * speed * delta)
	if collision:
		dir = dir.reflect(collision.normal)
		move_and_collide(dir * speed * delta)

######################### SIGNALS #########################
