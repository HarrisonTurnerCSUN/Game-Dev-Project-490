extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animation_player: AnimatedSprite2D
@export var Animation_Tree: AnimationTree

@export_category("Speed")
@export var speed : int = 150
@export var acceleration : int = 5
@export var max_horizontal_speed : int = 150
var direction: Vector2
#var last_direction := Vector2(0,-1)
var last_direction : Vector2

func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	direction.x = GameInputEvents.movement_input()
	direction.y = GameInputEvents.movement_input_y()
	
	var input = direction.normalized()
	last_direction = character_body_2d.velocity.normalized()
	character_body_2d.velocity = lerp(character_body_2d.velocity, input * speed, _delta * acceleration)
	
	#Animation_Tree.set("parameters/Walk_BlendSpace2D/blend_position",input)
	
	character_body_2d.move_and_slide()
	#Transitions
	if direction.x == 0 and direction.y == 0:
		transition.emit("Idle")
		
	#if direction and GameInputEvents.shift_input():
	#	transition.emit("Run")
	
func enter():
	direction.x = GameInputEvents.movement_input()
	direction.y = GameInputEvents.movement_input_y()
	
	#var input = direction.normalized()
	#last_direction = character_body_2d.velocity.normalized()
	#Animation_Tree.set("parameters/Walk_BlendSpace2D/blend_position",input)
	
	character_body_2d.move_and_slide()
	
func exit():
	#animation_player.stop()
	pass
