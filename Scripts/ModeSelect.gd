extends Control

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################



######################### BUILT-INS #########################

func _ready() -> void:
	pass

######################### SIGNALS #########################


func _on_FiveButton_pressed() -> void:
	SceneSwitcher.goto_scene("res://Scenes/BestOf5.tscn")


func _on_EndlessButton_pressed() -> void:
	SceneSwitcher.goto_scene("res://Scenes/Endless.tscn")


func _on_BackButton_pressed() -> void:
	SceneSwitcher.go_home()


func _on_TenButton_pressed() -> void:
	SceneSwitcher.goto_scene("res://Scenes/BestOf10.tscn")
