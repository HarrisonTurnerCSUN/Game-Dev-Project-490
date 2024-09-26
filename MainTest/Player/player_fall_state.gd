extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var gravity := 450.0

func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	character_body_2d.velocity.y = gravity * _delta
	
	character_body_2d.move_and_slide()
	
	#Transition
	if character_body_2d.is_on_floor():
		transition.emit("Idle")
	
	
func enter():
	animated_sprite_2d.play("idle")
	
func exit():
	animated_sprite_2d.stop()
	
