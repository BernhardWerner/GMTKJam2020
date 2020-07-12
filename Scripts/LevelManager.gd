extends Node2D
class_name LevelManager


export var tribe_data : Resource
export var start_population := 10
export var max_population := 20

const animal_scene = preload("res://Scenes/Animal.tscn")

const animal_sprites = [preload("res://Graphics/icons/circ16x16black.png"), preload("res://Graphics/icons/circ16x16white.png")]

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################

func populate_level() -> void:
	if tribe_data:
		for i in range(start_population):
			spawn_animal(Math.rand_pos(), Tribes.HUNTER if i <= start_population * tribe_data.hunter_ratio else Tribes.PREY)


func spawn_animal(pos: Vector2, tribe: int) -> void:
	var animal = animal_scene.instance()
	
	animal.tribe = tribe
	animal.global_position = pos
	animal.hunter_food_threshold = tribe_data.hunter_food_threshold
	
	animal.color = tribe_data.colors[tribe]
	animal.sprite_texture = animal_sprites[tribe]
	animal.speed = tribe_data.speeds[tribe]
	animal.dir = Math.rand_dir()
	animal.end_age = tribe_data.ages_mean[tribe] + (randf() - 1) * tribe_data.ages_range[tribe]
	animal.connect("reproducing", self, "_on_Animal_reproducing")
	animal.connect("dead", get_parent(), "_on_Animal_dying")
	
	$Animals.add_child(animal)

	
	



######################### BUILT-INS #########################

func _ready() -> void:
	pass
		

func _input(event: InputEvent) -> void:
	##### DEBUG CONTROLS
	if event is InputEventKey:
		match event.scancode:
			KEY_R:
				get_tree().reload_current_scene()
			KEY_ESCAPE:
				get_tree().quit()
				
######################### SIGNALS #########################

func _on_Animal_reproducing(animal: Animal) -> void:
	if $Animals.get_child_count() < max_population if animal.tribe == Tribes.PREY else 1.5 * max_population:
		spawn_animal(animal.global_position - animal.dir, animal.tribe)


