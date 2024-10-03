extends NodeState

@export var character_body_2d : CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"

@export_category("Player Crouch Walk state")
@export var speed : int = 150
@export var max_horizontal_speed : int = 150

func on_process(_delta :float):
	var direction : float = GameInputEvents.movement_input()
	
	#This allows increasing speed with an upper and lower bound
	#ie: you can build momentum up to a cap, this could be fun(ny)
	if direction:
		character_body_2d.velocity.x += direction * speed
		character_body_2d.velocity.x = clampi(character_body_2d.velocity.x, -max_horizontal_speed,max_horizontal_speed)
	
	if direction != 0:
		sprite_2d.flip_h = false if direction > 0 else true
		
	character_body_2d.move_and_slide()
		
		
	#Transitions
	if character_body_2d.is_on_floor() && !GameInputEvents.control_input():
		transition.emit("Idle")
		
	if !character_body_2d.is_on_floor() and character_body_2d.velocity.y > 0:
		transition.emit("Fall")
		
func on_physics_process(_delta :float):
	pass
	
func enter():
	animation_player.play("Crouch_Walk")
	
func exit():
	pass
