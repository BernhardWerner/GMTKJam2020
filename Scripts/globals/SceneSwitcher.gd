extends Node

var current_scene = null

######################### CUSTOM METHODS #########################

func deferred_goto_scene(path) -> void:
	var new_scene = ResourceLoader.load(path)
	
	current_scene.free()
	current_scene = new_scene.instance()

	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
	
func go_home() -> void:
	goto_scene("res://Scenes/Menus/MainMenu.tscn")
	
	
func goto_scene(path) -> void:
	call_deferred("deferred_goto_scene", path)
	

######################### BUILT-INS #########################	
	
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	

