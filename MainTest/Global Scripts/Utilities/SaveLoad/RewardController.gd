extends Node

const RewardScreen := preload("res://main menu/Reward Menu/RewardScreen.tscn")

func show_reward_screen():
	var screen = RewardScreen.instantiate()
	get_tree().current_scene.add_child(screen)
