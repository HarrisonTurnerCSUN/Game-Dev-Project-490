class_name GameInputEvents
extends Node

static func movement_input() -> float:
	var direction : float = Input.get_axis("move_left","move_right")
	return direction
	
static func jump_input()->bool:
	var jump_input : bool = Input.is_action_just_pressed("jump")
	return jump_input
