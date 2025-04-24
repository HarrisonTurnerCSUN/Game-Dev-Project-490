extends NodeState

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	animation_player.play("Death")
	print("death entered")

func on_physics_process(_delta):
	# Prevent movement or transitions
	pass

func exit():
	animation_player.stop()
