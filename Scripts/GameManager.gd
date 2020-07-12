extends Node2D

export var number_of_levels := 3

var all_possible_tribes := []

var level_index := 0
var player_choices := []
var current_tribe_data := preload("res://TribeData/tribes00.tres")
var current_observation_time := 30

onready var info_pop_number := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/PopNumber
onready var info_speed := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/Speeds
onready var info_prey_time := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/PreyTime
onready var info_hunter_time := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/HunterTime
onready var info_hunter_ratio := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/HunterRatio
onready var info_hunter_hunger := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/HunterHunger
onready var info_obs_time := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/ObsTime

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################

func list_files_in_directory(path: String) -> Array:
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
	
	
func start_level() -> void:
	$GUI/StartInstructions.hide()
	$Level.tribe_data = current_tribe_data
	$Level.populate_level()
	$ObservationTimer.start()
	$Level/CanvasLayer/ObservationTimeLabel.show()

func update_info_box() -> void:
	info_pop_number.text    = "Current population:   " + $Level.start_population as String
	info_speed.text         = "Speed ratio:   "  + (0.1 * round(10 * current_tribe_data.speeds[Tribes.HUNTER] / current_tribe_data.speeds[Tribes.PREY])) as String + " : 1"
	info_prey_time.text     = "Prey procreation:   " + current_tribe_data.ages_mean[Tribes.PREY] as String + " sec"
	info_hunter_time.text   = "Predator survival:   " + current_tribe_data.ages_mean[Tribes.HUNTER] as String + " sec"
	info_hunter_ratio.text  = "Predator ratio:   " + round(100 * current_tribe_data.hunter_ratio) as String  + "%"
	info_hunter_hunger.text = "Predator hunger:   " + current_tribe_data.hunter_food_threshold as String
	info_obs_time.text      = "Observation time:   " + current_observation_time as String + " sec"

######################### BUILT-INS #########################

func _ready() -> void:
	all_possible_tribes = list_files_in_directory("res://TribeData/")
	all_possible_tribes.shuffle()
	current_tribe_data = load("res://TribeData/" + all_possible_tribes[0])
	update_info_box()
	$Level/CanvasLayer/ObservationTimeLabel.text = "Time left: " + current_observation_time as String
	$ObservationTimer.wait_time = current_observation_time


func _process(delta: float) -> void:
	$Level/CanvasLayer/ObservationTimeLabel.text = "Time left: " + round($ObservationTimer.time_left) as String

######################### SIGNALS #########################


func _on_HunterButton_pressed() -> void:
	player_choices.push_back(Tribes.HUNTER)
	start_level()


func _on_PreyButton_pressed() -> void:
	player_choices.push_back(Tribes.PREY)
	start_level()


func _on_BothButton_pressed() -> void:
	player_choices.push_back(-1)
	start_level()
	
