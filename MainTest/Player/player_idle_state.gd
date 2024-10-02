extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export_category("Friction")
@export var friction : int = 500

func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x,0,friction)
	
	character_body_2d.move_and_slide()
	
	#Transitions
	if !character_body_2d.is_on_floor():
		transition.emit("Fall")
	
	var direction : float = GameInputEvents.movement_input()
	if direction and character_body_2d.is_on_floor():
		transition.emit("Run")
		
	if GameInputEvents.jump_input():
		transition.emit("Jump")
	
func enter():
	animated_sprite_2d.play("idle")
	
func exit():
	animated_sprite_2d.stop()
	
