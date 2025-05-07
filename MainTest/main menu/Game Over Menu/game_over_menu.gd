extends Control  # or Control, depending on your setup

var GameOverScreen := preload("res://main menu/Game Over Menu/game_over_menu.tscn")

func _ready():
	print("game menu")
	get_tree().paused = true
	if player:
		var call = Callable(self, "make_death_scene_visible")
		player.connect("death", call)

func show_menu():
	visible = true
	get_tree().paused = true  # Optional: freeze the game while menu is up

func _on_retry_pressed():
	visible = false
	get_tree().paused = false
 
func _on_quit_pressed():
	get_tree().quit()

@export var player: CharacterBody2D

func make_death_scene_visible() -> void:
	$"PathToYourGameOverMenu".visible = true
