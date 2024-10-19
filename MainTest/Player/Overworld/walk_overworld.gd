extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animation_player: AnimatedSprite2D

@export_category("Speed")
@export var speed : int = 200
@export var acceleration : int = 2
@export var max_horizontal_speed : int = 200
var direction: Vector2
func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	direction.x = GameInputEvents.movement_input()
	direction.y = GameInputEvents.movement_input_y()
	
	var input = direction.normalized()
	
	character_body_2d.velocity = lerp(character_body_2d.velocity, input * speed, _delta * acceleration)
		
	character_body_2d.move_and_slide()
	
	#if direction.x != 0:
	#	animation_player.flip_h = true if direction.x > 0 else false
	if direction.x > 0:
		animation_player.play("RunEast")
	if direction.x < 0:
		animation_player.play("RunWest")
	if direction.y > 0  || (direction.y > 0 && direction.x != 0):
		animation_player.play("RunSouth")
	if direction.y < 0 || (direction.y < 0 && direction.x != 0):
		animation_player.play("RunNorth")
	#Transitions
	if direction.x == 0 and direction.y == 0:
		transition.emit("Idle")
		
	#if direction and GameInputEvents.shift_input():
	#	transition.emit("Run")
	
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
	#if direction.x > 0:
		#animation_player.play("RunWest")
	#if direction.x < 0:
		#animation_player.play("RunEast")
	#if direction.y > 0  || (direction.y > 0 && direction.x != 0):
		#animation_player.play("RunSouth")
	#if direction.y < 0  || (direction.y > 0 && direction.x != 0):
		#animation_player.play("RunNorth")
	
func exit():
	animation_player.stop()
