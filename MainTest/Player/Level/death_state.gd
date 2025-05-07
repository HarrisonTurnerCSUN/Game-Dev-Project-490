extends NodeState

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"


func enter():
	animation_player.play("Death")
	print("death entered")
	get_tree().paused = true
	
	GameOverController.show_game_over_screen()

func on_physics_process(_delta):
	# Prevent movement or transitions
	pass

func exit():
	animation_player.stop()
