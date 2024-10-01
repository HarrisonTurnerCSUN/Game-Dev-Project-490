extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export_category("Jump state")
@export var jump : float = -350
@export var jump_speed : int = 200
@export var max_jump_speed : int = 200

@export var gravity : int = 800

func on_process(_delta :float):
	
	character_body_2d.velocity.y += gravity * _delta
	
	if character_body_2d.is_on_floor():
		character_body_2d.velocity.y = jump
	
	var direction : float = GameInputEvents.movement_input() 
	
	if !character_body_2d.is_on_floor():
		character_body_2d.velocity.x += direction * jump_speed
		character_body_2d.velocity.x = clampi(character_body_2d.velocity.x, -max_jump_speed,max_jump_speed)
		
	character_body_2d.move_and_slide()
	
	if character_body_2d.is_on_floor():
		transition.emit("Idle")
	
func on_physics_process(_delta :float):
	pass
	
func enter():
	pass
	
func exit():
	pass
	
