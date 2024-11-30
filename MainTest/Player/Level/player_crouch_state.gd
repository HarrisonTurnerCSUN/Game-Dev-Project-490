extends NodeState

@export var character_body_2d : CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"

@export_category("Crouch state")
@export var gravity : int = 800

func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	var direction : float = GameInputEvents.movement_input()
	
	if direction != 0:
		sprite_2d.flip_h = false if direction > 0 else true 
		
		
	#Transitions
	if character_body_2d.is_on_floor() && !GameInputEvents.control_input():
		transition.emit("Idle")
		
	if !character_body_2d.is_on_floor() and character_body_2d.velocity.y > 0:
		transition.emit("Fall")
	
	if direction and character_body_2d.is_on_floor():
		transition.emit("CrouchWalk")
		
	if GameInputEvents.shift_input():
		transition.emit("Roll")
	
func enter():
	animation_player.play("Crouch")
	
func exit():
	pass
