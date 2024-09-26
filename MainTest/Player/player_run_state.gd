extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export_category("Player run state")
@export var speed : int = 200
@export var max_horizontal_speed : int = 600

func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	var direction : float = GameInputEvents.movement_input()
	
	#This allows increasing speed with an upper and lower bound
	#ie: you can build momentum up to a cap, this could be fun(ny)
	if direction:
		character_body_2d.velocity.x += direction * speed
		character_body_2d.velocity.x = clampi(character_body_2d.velocity.x, -max_horizontal_speed,max_horizontal_speed)
	
	if direction != 0:
		animated_sprite_2d.flip_h = false if direction > 0 else true
		
	character_body_2d.move_and_slide()
	
	#Transition
	if direction == 0:
		transition.emit("Idle")
	
func enter():
	animated_sprite_2d.play("run")
	
func exit():
	animated_sprite_2d.stop()
