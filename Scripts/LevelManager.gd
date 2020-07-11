extends Node2D

export var start_population := 10
export var max_population := 20

const animal_scene = preload("res://Scenes/Animal.tscn")

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################

func rand_pos() -> Vector2:
	return GlobalVariables.living_space.position + Vector2(randf() * GlobalVariables.living_space.size.x, randf() * GlobalVariables.living_space.size.y)

func spawn_animal(pos: Vector2, tribe: int) -> void:
	var animal = animal_scene.instance()
	animal.tribe = tribe
	animal.global_position = pos
	animal.connect("reproducing", self, "_on_Animal_reproducing")
	$Animals.add_child(animal)

######################### BUILT-INS #########################

func _ready() -> void:
	for i in range(start_population):
		spawn_animal(rand_pos(), Tribes.PREY)
		

func _input(event: InputEvent) -> void:
	##### DEBUG CONTROLS
	if event is InputEventKey:
		match event.scancode:
			KEY_R:
				get_tree().reload_current_scene()
			KEY_ESCAPE:
				get_tree().quit()
				
######################### SIGNALS #########################

func _on_Animal_reproducing(pos: Vector2, tribe: int) -> void:
	if $Animals.get_child_count() < max_population:
		spawn_animal(pos, tribe)
