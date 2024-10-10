extends NodeState

@export var character_body_2d : CharacterBody2D
@export var gravity : int = 700
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	character_body_2d.velocity.y += gravity * _delta
	
	character_body_2d.move_and_slide()
	
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
	
