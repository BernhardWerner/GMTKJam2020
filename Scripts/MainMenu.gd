extends Control

######################### SETTERS & GETTERS #########################


######################### CUSTOM METHODS #########################


######################### BUILT-INS #########################

func _ready() -> void:
	pass

######################### SIGNALS #########################


func _on_StartButton_pressed() -> void:
	SceneSwitcher.goto_scene("res://Scenes/GameManager.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
