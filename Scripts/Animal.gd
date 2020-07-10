extends KinematicBody2D
class_name Animal

var tribe : int
var dir : Vector2
var speed : float

signal reproducing
######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################

func setup() -> void:
	tribe = round(randf())
	$Sprite.modulate = Tribes.colors[tribe]
	speed = Tribes.speeds[tribe]
	var angle = 2 * PI * randf()
	dir = Vector2(sin(angle), cos(angle))
	global_position = GlobalVariables.living_space.position + Vector2(randf() * GlobalVariables.living_space.size.x, randf() * GlobalVariables.living_space.size.y)
	match tribe:
		Tribes.HUNTER:
			$AgeTimer.wait_time = 1.0;
		Tribes.PREY:
			$AgeTimer.wait_time = 1.0;
	$AgeTimer.start()
	

######################### BUILT-INS #########################

func _ready() -> void:
	setup()
	connect("reproducing", get_parent().get_parent(), "_on_Animal_reproducing", [self])


func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(dir * speed * delta)
	if collision:
		dir = -dir.reflect(-collision.normal)
		
				
######################### SIGNALS #########################


func _on_AgeTimer_timeout() -> void:
	match tribe:
		Tribes.HUNTER:
			self.queue_free()
		Tribes.PREY:
			emit_signal("reproducing")
