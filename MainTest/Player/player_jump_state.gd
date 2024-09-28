extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export_category("Jump state")
@export var jump : float = -300
@export var jump_speed : int = 200
@export var max_jump_speed : int = 1000

@export var gravity : int = 450

func on_process(_delta :float):
	
	if character_body_2d.is_on_floor():
		character_body_2d.velocity.y = jump
	
	var direction : float = GameInputEvents.movement_input() 
	
	if !character_body_2d.is_on_floor():
		character_body_2d.velocity.x += direction * jump_speed
		character_body_2d.velocity.x = clampi(character_body_2d.velocity.x, -max_jump_speed,max_jump_speed)
	
func on_physics_process(_delta :float):
	pass
	
func enter():
	pass
	
func exit():
	pass
	
