extends Node2D

enum MODES {FIVE, TEN, ENDLESS}

var mode : int = MODES.FIVE
var number_of_levels := 5

var all_possible_tribes := []

var levels_completed := 0
var player_choices := []
var current_tribe_data := preload("res://TribeData/tribes00.tres")
var current_observation_time := 30

var actual_results := []

onready var info_pop_number := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/PopNumber
onready var info_speed := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/Speeds
onready var info_prey_time := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/PreyTime
onready var info_hunter_time := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/HunterTime
onready var info_hunter_ratio := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/HunterRatio
onready var info_hunter_hunger := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/HunterHunger
onready var info_obs_time := $GUI/StartInstructions/HBoxContainer/VBoxLeft/InfoBox/ObsTime

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################

func finish_round() -> void:
	$Level/CanvasLayer/ObservationTimeLabel.hide()
	$GUI/RoundResult.show()

func finish_run() -> void:
	$GUI/OverallResult.show()

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



func prepare_round() -> void:
	all_possible_tribes = list_files_in_directory("res://TribeData/")
	if levels_completed < 5:
		current_tribe_data = load("res://TribeData/" + all_possible_tribes[levels_completed])
	else:
		current_tribe_data = load("res://TribeData/" + all_possible_tribes.back())
	update_info_box()



func start_round() -> void:
	prepare_round()
	$GUI/StartInstructions.hide()
	$Level.tribe_data = current_tribe_data
	$Level.populate_level()
	$ObservationTimer.start()
	$Level/CanvasLayer/ObservationTimeLabel.show()
	$Level/CanvasLayer/ObservationTimeLabel.text = "Time left: " + current_observation_time as String
	$ObservationTimer.wait_time = current_observation_time
	$ObservationTimer.start()



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
	match mode:
		MODES.FIVE:
			number_of_levels = 5
		MODES.TEN:
			number_of_levels = 10
		MODES.ENDLESS:
			number_of_levels = 1000

	prepare_round()


func _process(delta: float) -> void:
	$Level/CanvasLayer/ObservationTimeLabel.text = "Time left: " + round($ObservationTimer.time_left) as String

######################### SIGNALS #########################




func _on_BothButton_pressed() -> void:
	player_choices.push_back(2)
	start_round()


func _on_NoneButton_pressed() -> void:
	player_choices.push_back(1)
	start_round()


func _on_PreyButton_pressed() -> void:
	player_choices.push_back(0)
	start_round()

func _on_ObservationTimer_timeout() -> void:
	get_tree().paused = true
	var survivors := $Level/Animals.get_children()
	if survivors.size() == 0:
		actual_results.push_back(0)
	else:
		var found_hunter := false
		for animal in survivors:
			if animal.tribe == Tribes.HUNTER:
				found_hunter = true
				break
		actual_results.push_back(2 if found_hunter else 1)
	
	for animal in survivors:
		animal.queue_free()
	
	levels_completed += 1
	if levels_completed >= number_of_levels:
		finish_run()
	else:
		finish_round()
	
	


func _on_QuitButton_pressed() -> void:
	SceneSwitcher.go_home()


func _on_ContinueButton_pressed() -> void:
	prepare_round()
	$GUI/RoundResult.hide()
	$GUI/StartInstructions.show()
	
func _on_Animal_dying() -> void:
	if $Level/Animals.get_child_count() == 0:
		$ObservationTimer.stop()
		$ObservationTimer.emit_signal("timeout")
