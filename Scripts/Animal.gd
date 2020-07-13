extends KinematicBody2D
class_name Animal

var tribe : int
var dir : Vector2
var speed : float

var color : Color
var sprite_texture : Texture
var end_age : float
var hunter_food_threshold : int

var food := 0

onready var sprite := $Sprite
onready var age_timer := $AgeTimer

signal reproducing(ani)
signal dead

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################

func setup() -> void:
	if tribe == Tribes.PREY:
		$PerceptionArea.queue_free()
	sprite.texture = sprite_texture 
#	sprite.material = preload("res://Materials/Animal.material").duplicate()
#	sprite.material.set_shader_param("rim_color", color)
	age_timer.wait_time = end_age
	age_timer.start()

######################### BUILT-INS #########################

func _ready() -> void:
	setup()


func _physics_process(delta: float) -> void:
	if randf() < 0.01:
		dir = Math.rand_dir()
	move_and_slide(dir * speed)

	if global_position.x <= GameManager.living_space.position.x or global_position.x >= GameManager.living_space.end.x:
		dir = -dir.reflect(Vector2.RIGHT)
		move_and_slide(1.1 * dir * speed)
	if global_position.y <= GameManager.living_space.position.y or global_position.y >= GameManager.living_space.end.y:
		dir = -dir.reflect(Vector2.UP)
		move_and_slide(1.1 * dir * speed)
		
				
######################### SIGNALS #########################


func _on_AgeTimer_timeout() -> void:
	match tribe:
		Tribes.HUNTER:
			emit_signal("dead")
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
