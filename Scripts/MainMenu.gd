extends Control

var tutorial_index := 0

onready var left_button := $HBoxContainer/TutorialBox/TutorialButtonBox/LeftButton
onready var right_button := $HBoxContainer/TutorialBox/TutorialButtonBox/RightButton
onready var all_pages := $HBoxContainer/TutorialBox/TutorialContent.get_children()

######################### SETTERS & GETTERS #########################

######################### CUSTOM METHODS #########################

func update_tutorial_page() -> void:
	for p in all_pages:
		p.hide()
	all_pages[tutorial_index].show()
	
######################### BUILT-INS #########################

func _ready() -> void:
	pass

######################### SIGNALS #########################


func _on_StartButton_pressed() -> void:
	SceneSwitcher.goto_scene("res://Scenes/ModeSelect.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_LeftButton_pressed() -> void:
	tutorial_index = max(0, tutorial_index - 1)
	if tutorial_index == 0:
		left_button.disabled = true
	right_button.disabled = false
	update_tutorial_page()


func _on_RightButton_pressed() -> void:
	tutorial_index = min(tutorial_index + 1, all_pages.size() - 1)
	if tutorial_index == all_pages.size() - 1:
		right_button.disabled = true
	left_button.disabled = false
	update_tutorial_page()
