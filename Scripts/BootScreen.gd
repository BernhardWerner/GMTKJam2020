extends Node2D

######################### CUSTOM METHODS #########################

func go_to_main_menu() -> void:
	SceneSwitcher.go_home()

######################### BUILT-INS #########################

func _ready():
	pass


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	go_to_main_menu()
