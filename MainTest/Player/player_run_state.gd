extends NodeState

@export var character_body_2d : CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"

@export_category("Player run state")
@export var speed : int = 200
@export var max_horizontal_speed : int = 200

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
		sprite_2d.flip_h = false if direction > 0 else true
		
	character_body_2d.move_and_slide()
	
	#Transition
	if direction == 0:
		transition.emit("Idle")
		
	if GameInputEvents.jump_input():
		transition.emit("Jump")
		
	if GameInputEvents.attack1_input():
		transition.emit("Attack1")
	
	if !character_body_2d.is_on_floor():
		transition.emit("Fall")
		
	if GameInputEvents.control_input() && character_body_2d.velocity.x < 1:
		transition.emit("Crouch")
		
	if GameInputEvents.control_input() && character_body_2d.velocity.x >= 1:
		transition.emit("Slide")
		
	if GameInputEvents.shift_input():
		transition.emit("Dash")
	
func enter():
	animation_player.play("Run")
	
func exit():
	animation_player.stop()
