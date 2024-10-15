extends NodeState

@export var character_body_2d : CharacterBody2D
@export var gravity : int = 700
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"

@export_category("Jump state")
@export var fall_horizontal_speed : int = 200
@export var max_fall_horizontal_speed : int = 200

func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	character_body_2d.velocity.y += gravity * _delta
	var direction : float = GameInputEvents.movement_input()
	
	if direction != 0:
		sprite_2d.flip_h = false if direction > 0 else true 
	
	if !character_body_2d.is_on_floor():
		character_body_2d.velocity.x += direction * fall_horizontal_speed
		character_body_2d.velocity.x = clampi(character_body_2d.velocity.x, 
												-max_fall_horizontal_speed,
												max_fall_horizontal_speed)
	character_body_2d.move_and_slide()
	print("Fall")
	#Transition
	if character_body_2d.is_on_floor():
		transition.emit("Idle")
		
	if GameInputEvents.shift_input():
		transition.emit("AirDash")
	
	if GameInputEvents.jump_input():
		print("double")
		transition.emit("DoubleJump")
	
func enter():
	animation_player.play("Fall")
	
func exit():
	animation_player.stop()
	
