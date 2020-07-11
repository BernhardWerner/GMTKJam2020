extends KinematicBody2D
class_name Animal

var tribe : int = Tribes.PREY
var dir : Vector2
var speed : float

signal reproducing(pos, tri)
######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################

func setup() -> void:
	$Sprite.modulate = Tribes.colors[tribe]
	speed = Tribes.speeds[tribe]
	var angle = 2 * PI * randf()
	dir = Vector2(sin(angle), cos(angle))
	$AgeTimer.wait_time = Tribes.ages_mean[tribe] + (randf() - 1) * Tribes.ages_range[tribe]
	$AgeTimer.start()
	

######################### BUILT-INS #########################

func _ready() -> void:
	setup()


func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(dir * speed * delta)
	if collision:
		dir = -dir.reflect(collision.normal)
		
				
######################### SIGNALS #########################


func _on_AgeTimer_timeout() -> void:
	match tribe:
		Tribes.HUNTER:
			self.queue_free()
		Tribes.PREY:
			emit_signal("reproducing", global_position - dir, tribe)
			
