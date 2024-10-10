extends NodeState

@export var character_body_2d : CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@export var gravity : int = 700
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
		
	if GameInputEvents.attack1_input():
		transition.emit("Attack1")
		
	if GameInputEvents.control_input():
		transition.emit("Crouch")
	
func enter():
	animation_player.play("Idle")
	
func exit():
	animation_player.stop()
	
