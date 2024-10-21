extends CharacterBody2D

@onready var animation_player = $AnimatedSprite2D/AnimationTree

func _physics_process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		animation_player.get("parameters/playback").travel("Idle_BlendSpace2D")
	else:
		animation_player.get("parameters/playback").travel("Walk_BlendSpace2D")
		animation_player.set("parameters/Idle_BlendSpace2D/blend_position",velocity)
		animation_player.set("parameters/Walk_BlendSpace2D/blend_position",velocity)
