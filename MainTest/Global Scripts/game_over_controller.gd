extends Node

const GameOverScreen := preload("res://main menu/Game Over Menu/game_over_menu.tscn")

func show_reward_screen():
	var screen = GameOverScreen.instantiate()
	get_tree().current_scene.add_child(screen)
	

func show_game_over_screen():
	var screen = GameOverScreen.instantiate()
	get_tree().current_scene.add_child(screen)

	# Make sure the instance has the method `show_menu()` in GameOverMenu.gd
	if screen.has_method("show_menu"):
		screen.show_menu()
	else:
		push_warning("GameOverScreen is missing 'show_menu()' method.")
	
