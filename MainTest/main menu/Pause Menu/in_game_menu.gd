extends Control

@onready var sceneChangeAnim = get_tree().current_scene.get_node("CanvasLayer/SceneTransition")
@onready var popup = $Save_Confirmation_Popup
@onready var options = $MarginContainer/Options
@onready var stats = $MarginContainer/Stats
@onready var comp_button = $MarginContainer/Options/VBoxContainer/VBoxContainer/ExitToOverworld
@onready var comp_label = $MarginContainer/Stats/VBoxContainer3/LevelComplete
@onready var stats_button = $"MarginContainer/Options/VBoxContainer/VBoxContainer2/ToStats"

@onready var star1 = $MarginContainer/Stats/VBoxContainer3/HBoxContainer/Star
@onready var star2 = $MarginContainer/Stats/VBoxContainer3/HBoxContainer/Star2
@onready var star3 = $MarginContainer/Stats/VBoxContainer3/HBoxContainer/Star3

@export var stopwatch_label : Label

@export var is_level_complete : bool = false

@export var  is_stats_hidden : bool = false

@export_multiline var goal1_text : String
@onready var goal1 : Label = $MarginContainer/Stats/VBoxContainer3/VBoxContainer2/Goal1
@export_multiline var goal2_text : String
@onready var goal2 : Label = $MarginContainer/Stats/VBoxContainer3/VBoxContainer2/Goal2
@export_multiline var goal3_text : String
@onready var goal3 : Label = $MarginContainer/Stats/VBoxContainer3/VBoxContainer2/Goal3

var stopwatch : Stopwatch

func _ready() -> void:
	print(get_tree().current_scene.scene_file_path)
	SaveController.setSavedScene(get_tree().current_scene.scene_file_path)
	SaveController.loadPlayer()
	#var busIndex
	#busIndex = AudioServer.get_bus_index("Master")
	#AudioServer.set_bus_volume_db(busIndex, linear_to_db(SaveController.gameData.MasterVol));
	#busIndex = AudioServer.get_bus_index("Music")
	#AudioServer.set_bus_volume_db(busIndex, linear_to_db(SaveController.gameData.MusicVol));
	#busIndex = AudioServer.get_bus_index("SFX")
	#AudioServer.set_bus_volume_db(busIndex, linear_to_db(SaveController.gameData.SFXVol));
	goal1.text = goal1_text
	goal2.text = goal2_text
	goal3.text = goal3_text
	stopwatch = get_tree().get_first_node_in_group("Stopwatch")
	if is_stats_hidden:
		stats_button.hide()
		
	if get_tree().current_scene.scene_file_path == "res://Overworld/overworld.tscn":
		$MarginContainer/Options/VBoxContainer/VBoxContainer/ExitToOverworld.visible = false
	else:
		$MarginContainer/Options/VBoxContainer/VBoxContainer/ExitToOverworld.visible = true
func resume():
	get_tree().paused = false
	$".".hide()
	
func pause():
	get_tree().paused = true
	$".".show()


func _on_resume_pressed() -> void:
	resume()


func _on_quit_pressed() -> void:
	popup.destination = "Quit"
	SaveController.savePlayer()
	popup.show()
	#get_tree().quit()
	
func _process(_delta: float) -> void:
	if is_stats_hidden:
		stats_button.hide()
	update_stopwatch()
	if Input.is_action_just_pressed("Escape") and get_tree().paused == true:
		resume()
	elif Input.is_action_just_pressed("Escape") and get_tree().paused == false:
		pause()
		
	if is_level_complete == true:
		Engine.time_scale -= 0.1
		if Engine.time_scale <= 0.2:
			level_complete_sequence()
			is_level_complete = false
		
		

func level_complete_sequence() -> void:
	await get_tree().create_timer(0.5).timeout
	pause()
	stats_button.text = "Return"
	options.hide()
	stats.show()
	comp_button.show()
	comp_label.show()
	
func _on_main_menu_pressed() -> void:
	#get_tree().paused = false
	#get_tree().change_scene_to_file("res://main menu/menu.tscn")
	popup.destination = "Main Menu"
	SaveController.savePlayer()
	popup.show()
	


func _on_to_options_pressed() -> void:
	stats.hide()
	options.show()


func _on_to_stats_pressed() -> void:
	options.hide()
	stats.show()
	
func flip_star1() -> void:
	star1.complete = !star1.complete
	star1.check_complete()

func flip_star2() -> void:
	star2.complete = !star2.complete
	star2.check_complete()

func flip_star3() -> void:
	star3.complete = !star3.complete
	star3.check_complete()
	
func update_stopwatch():
	stopwatch_label.text = stopwatch.time_to_string()


func _on_exit_to_overworld_pressed() -> void:
	#stats.hide()
	#options.show()
	resume()
	stats_button.pressed
	stats_button.text = "Stats"
	comp_button.hide()
	comp_label.hide()
	Engine.time_scale = 1
	SaveController.saveGame();
	SaveController.savePlayer()
	sceneChangeAnim.play("fadeIn")
	await sceneChangeAnim.animation_finished
	get_tree().change_scene_to_file("res://Overworld/overworld.tscn")


func _on_level_end_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$MarginContainer/Stats/VBoxContainer3/VBoxContainer/ExitToOverworld.visible = true
		is_level_complete = true
		
func _set_is_complete() -> void:
		is_level_complete = true
		
func _run_saves() -> void:
	pass
