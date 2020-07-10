extends Node2D

export var start_population := 10
var max_population := 2 * start_population

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################



######################### BUILT-INS #########################

func _ready() -> void:
	var animal = preload("res://Scenes/Animal.tscn")
	for i in range(start_population):
		$Animals.add_child(animal.instance())

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		match event.scancode:
			KEY_R:
				get_tree().reload_current_scene()
			KEY_ESCAPE:
				get_tree().quit()
				
######################### SIGNALS #########################

func _on_Animal_reproducing(animal: Animal) -> void:
	var offspring = preload("res://Scenes/Animal.tscn").instance()
	add_child(offspring)
	offspring.tribe = animal.tribe
	offspring.global_position = animal.global_position
