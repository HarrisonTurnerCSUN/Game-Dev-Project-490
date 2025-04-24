extends Control  # or Control, depending on your setup

func _ready():
	visible = false  # Start hidden unless game over happens
	if player:
		var call = Callable(self, "make_death_scene_visible")
		player.connect("death", call)

func show_menu():
	visible = true
	get_tree().paused = true  # Optional: freeze the game while menu is up

func _on_retry_pressed():
	visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()

@export var player: CharacterBody2D

func make_death_scene_visible() -> void:
	$"PathToYourGameOverMenu".visible = true
