extends Control

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################



######################### BUILT-INS #########################

func _ready() -> void:
	pass

######################### SIGNALS #########################


func _on_FiveButton_pressed() -> void:
	SceneSwitcher.load_game(GameManager.MODES.FIVE)


func _on_EndlessButton_pressed() -> void:
	SceneSwitcher.load_game(GameManager.MODES.ENDLESS)


func _on_BackButton_pressed() -> void:
	SceneSwitcher.go_home()


func _on_TenButton_pressed() -> void:
	SceneSwitcher.load_game(GameManager.MODES.TEN)
