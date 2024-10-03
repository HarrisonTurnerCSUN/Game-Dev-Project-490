class_name GameInputEvents
extends Node

static func movement_input() -> float:
	var direction : float = Input.get_axis("move_left","move_right")
	return direction
	
static func jump_input()->bool:
	var jump_input : bool = Input.is_action_just_pressed("jump")
	return jump_input
	
static func control_input()->bool:
	var control_input : bool = Input.is_action_pressed("control")
	return control_input
	
static func attack1_input()->bool:
	var attack1_input : bool = Input.is_action_just_pressed("left_click")
	return attack1_input

static func shift_input()->bool:
	var shift_input : bool = Input.is_action_just_pressed("shift")
	return shift_input
