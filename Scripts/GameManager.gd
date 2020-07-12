extends Node2D

enum MODES {FIVE, TEN, ENDLESS}

export var mode : int = MODES.FIVE
var number_of_levels := 5

var all_possible_tribes := []

var levels_completed := 0
var player_choices := []
var current_tribe_data := preload("res://TribeData/tribes00.tres")
var current_observation_time := 30

var consecutive_fails := 0

var actual_results := []

onready var info_pop_number := $StartInstructions/HBoxContainer/VBoxLeft/InfoBox/PopNumber
onready var info_speed := $StartInstructions/HBoxContainer/VBoxLeft/InfoBox/Speeds
onready var info_prey_time := $StartInstructions/HBoxContainer/VBoxLeft/InfoBox/PreyTime
onready var info_hunter_time := $StartInstructions/HBoxContainer/VBoxLeft/InfoBox/HunterTime
onready var info_hunter_ratio := $StartInstructions/HBoxContainer/VBoxLeft/InfoBox/HunterRatio
onready var info_hunter_hunger := $StartInstructions/HBoxContainer/VBoxLeft/InfoBox/HunterHunger
onready var info_obs_time := $StartInstructions/HBoxContainer/VBoxLeft/InfoBox/ObsTime

######################### SETTERS & GETTERS #########################



######################### CUSTOM METHODS #########################

func finish_round() -> void:
	match actual_results.back():
		0:
			$RoundResult/VBoxContainer/ResultLabel.text = "No animal survived..."
		1:
			$RoundResult/VBoxContainer/ResultLabel.text = "Only the rabbits survived..."
		2:
			$RoundResult/VBoxContainer/ResultLabel.text = "Both wolves and rabbits survived!"
	if actual_results.back() == player_choices.back():
		$RoundResult/VBoxContainer/FeedbackLabel.text = "You made the correct prediction!"
	else:
		$RoundResult/VBoxContainer/FeedbackLabel.text = "You made the wrong prediction..."
	$ObservationTimeLabel.hide()
	$RoundResult.show()

func finish_run() -> void:
	$RoundResult.hide()
	var rate = 0;
	for i in range(actual_results.size()):
		if player_choices[i] == actual_results[i]:
			rate += 1
		
	if mode == MODES.ENDLESS:
		if rate == 1:
			$OverallResult/VBoxContainer/Result.text = "You've judged 1 biome correctly!"
		else:
			$OverallResult/VBoxContainer/Result.text = "You've judged " + rate as String + " biomes correctly!"
	else:
		$OverallResult/VBoxContainer/Result.text = "You've been " + round(100.0 * rate / actual_results.size()) as String + "% correct!"
	$OverallResult.show()

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
		current_tribe_data = load("res://TribeData/" + all_possible_tribes[0])
		randomize()
		current_tribe_data.hunter_ratio = 0.35 * randf() + 0.1
		current_tribe_data.hunter_food_threshold = 1 + randi() % 9
		current_tribe_data.speeds = [100 + 400 * randf(), 100 + 400 * randf()]
		current_tribe_data.ages_mean = [0.1 * round(10 * (2.0 + 6.0 * randf())), 0.1 * round(10 * 0.6 + 1.4 * randf())]
		
		current_observation_time = 20 + randi() % 20
		$Level.start_population = 20 + randi() % 80
	update_info_box()




func start_round() -> void:
	prepare_round()
	$StartInstructions.hide()
	$Level.tribe_data = current_tribe_data
	$Level.populate_level()
	$ObservationTimer.start()
	$ObservationTimeLabel.show()
	$ObservationTimeLabel.text = "Time left: " + current_observation_time as String
	$ObservationTimer.wait_time = current_observation_time
	$ObservationTimer.start()



func update_info_box() -> void:
	info_pop_number.text    = "Current population:   " + $Level.start_population as String
	info_speed.text         = "Speed ratio:   "  + (0.1 * round(10 * current_tribe_data.speeds[Tribes.HUNTER] / current_tribe_data.speeds[Tribes.PREY])) as String + " : 1"
	info_prey_time.text     = "Rabbit procreation:   " + current_tribe_data.ages_mean[Tribes.PREY] as String + " sec"
	info_hunter_time.text   = "Wolf survival:   " + current_tribe_data.ages_mean[Tribes.HUNTER] as String + " sec"
	info_hunter_ratio.text  = "Wolf ratio:   " + round(100 * current_tribe_data.hunter_ratio) as String  + "%"
	info_hunter_hunger.text = "Wolf hunger:   " + current_tribe_data.hunter_food_threshold as String
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
	$ObservationTimeLabel.text = "Time left: " + round($ObservationTimer.time_left) as String

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
	if mode == MODES.ENDLESS:
		if actual_results.back() != player_choices.back():
			consecutive_fails += 1
		else:
			consecutive_fails = 0
			
	if consecutive_fails >= 2:
		levels_completed = 2000
	
	get_tree().paused = false
	finish_round()




func _on_QuitButton_pressed() -> void:
	SceneSwitcher.go_home()


func _on_ContinueButton_pressed() -> void:

	if levels_completed < number_of_levels:
		prepare_round()
		$RoundResult.hide()
		$StartInstructions.show()
	else:
		finish_run()
	
func _on_Animal_dying() -> void:
	if $Level/Animals.get_child_count() <= 1:
		$ObservationTimer.stop()
		$ObservationTimer.emit_signal("timeout")
