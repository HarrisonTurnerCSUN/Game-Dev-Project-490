extends Control

@onready var popup = $Save_Confirmation_Popup
@onready var options = $MarginContainer/Options
@onready var stats = $MarginContainer/Stats

@onready var star1 = $MarginContainer/Stats/HBoxContainer/Star
@onready var star2 = $MarginContainer/Stats/HBoxContainer/Star2
@onready var star3 = $MarginContainer/Stats/HBoxContainer/Star3

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
	popup.show()
	#get_tree().quit()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and get_tree().paused == true:
		resume()
	elif Input.is_action_just_pressed("Escape") and get_tree().paused == false:
		pause()


func _on_main_menu_pressed() -> void:
	#get_tree().paused = false
	#get_tree().change_scene_to_file("res://main menu/menu.tscn")
	popup.destination = "Main Menu"
	popup.show()
	


func _on_to_options_pressed() -> void:
	stats.hide()
	options.show()


func _on_to_stats_pressed() -> void:
	options.hide()
	stats.show()
	
func flip_star1() -> void:
	star1.complete = true
	star1.check_complete()

func flip_star2() -> void:
	star2.complete = true
	star2.check_complete()

func flip_star3() -> void:
	star3.complete = true
	star3.check_complete()
