extends Node2D

export var number_of_animals := 10

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################



######################### BUILT-INS #########################

func _ready() -> void:
	var animal = preload("res://Scenes/Animal.tscn")
	for i in range(number_of_animals):
		$Animals.add_child(animal.instance())

######################### SIGNALS #########################
