extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animation_player: AnimatedSprite2D
@export_category("Friction")
@export var friction : int = 500
var direction: Vector2

func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x,0,friction)
	character_body_2d.velocity.y = move_toward(character_body_2d.velocity.y,0,friction)
	
	character_body_2d.move_and_slide()
	
	#Transitions
	var direction_x : float = GameInputEvents.movement_input()
	var direction_y : float = GameInputEvents.movement_input_y()
	
	direction.x = GameInputEvents.movement_input()
	direction.y = GameInputEvents.movement_input_y()
	
	#var input = direction.normalized()
	#
	#var Animation_Tree  = get_node("./AnimationTree")
	#var Playback = Animation_Tree.Get("parameters/playback")
	
	if direction_x or direction_y :
		transition.emit("Walk")
		
	if direction_x and GameInputEvents.shift_input():
		transition.emit("Run")
	
func enter():
	direction.x = GameInputEvents.movement_input()
	direction.y = GameInputEvents.movement_input_y()
	
	var input = direction.normalized()
	
	var Animation_Tree  = get_node("./AnimationTree")
	var Playback = Animation_Tree.Get("parameters/playback")
	
	if input == Vector2.ZERO:
		Playback.Travel("Idle_BlendSpace2D")
	else:
		Animation_Tree.Set("parameters/Idle_BlendSpace2D/blend_position", input)
	#if GameInputEvents.movement_input() > 0:
		#animation_player.play("IdleEast")
	#if GameInputEvents.movement_input() < 0:
		#animation_player.play("IdleWest")
	#if GameInputEvents.movement_input_y() > 0:
		#animation_player.play("IdleSouth")
	#if GameInputEvents.movement_input_y() < 0:
		#animation_player.play("IdleNorth")
	
func exit():
	animation_player.stop()
