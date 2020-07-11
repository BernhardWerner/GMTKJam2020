extends KinematicBody2D
class_name Animal

var tribe : int
var dir : Vector2
var speed : float

var color : Color
var end_age : float
var hunter_food_threshold : int

var food := 0

onready var sprite := $Sprite
onready var age_timer := $AgeTimer

signal reproducing(ani)

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################



######################### BUILT-INS #########################

func _ready() -> void:
	if tribe == Tribes.PREY:
		$PerceptionArea.queue_free()
	sprite.modulate = color
	age_timer.wait_time = end_age
	age_timer.start()


func _physics_process(delta: float) -> void:
	if randf() < 0.01:
		dir = Math.rand_dir()
	var collision : KinematicCollision2D = move_and_collide(dir * speed * delta)
	if collision:
		dir = -dir.reflect(collision.normal)
		
				
######################### SIGNALS #########################


func _on_AgeTimer_timeout() -> void:
	match tribe:
		Tribes.HUNTER:
			self.queue_free()
		Tribes.PREY:
			emit_signal("reproducing", self)


func _on_PerceptionArea_body_entered(body: Node) -> void:
	if body.tribe != self.tribe:
		body.queue_free()
		food += 1
		if food >= hunter_food_threshold:
			emit_signal("reproducing", self)
			food = 0
		age_timer.start()
