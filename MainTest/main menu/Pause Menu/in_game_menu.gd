extends Control

@onready var popup = $Save_Confirmation_Popup

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
	
