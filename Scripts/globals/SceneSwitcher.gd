extends Node

var current_scene = null

######################### CUSTOM METHODS #########################

func deferred_goto_scene(path: String, args: Dictionary) -> void:
	var new_scene = ResourceLoader.load(path)
	
	current_scene.free()
	current_scene = new_scene.instance()
	if not args.empty():
		for key in args.keys():
			current_scene.set(key, args[key])

	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
	
func go_home() -> void:
	goto_scene("res://Scenes/Menus/MainMenu.tscn")
	
	
func goto_scene(path: String, args: Dictionary = {}) -> void:
	call_deferred("deferred_goto_scene", path, args)
	

func load_game(m: int) -> void:
	goto_scene("res://Scenes/GameManager.tscn", {"mode": m})
	
######################### BUILT-INS #########################	
	
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	

