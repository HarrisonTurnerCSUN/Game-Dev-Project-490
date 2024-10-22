extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animation_player: AnimatedSprite2D
@export var Animation_Tree: AnimationTree
@export_category("Friction")
@export var friction : int = 500
var direction: Vector2
#var last_direction := Vector2(0,-1)
var last_direction : Vector2
func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x,0,friction)
	character_body_2d.velocity.y = move_toward(character_body_2d.velocity.y,0,friction)
	
	var direction_x : float = GameInputEvents.movement_input()
	var direction_y : float = GameInputEvents.movement_input_y()
	
	direction.x = GameInputEvents.movement_input()
	direction.y = GameInputEvents.movement_input_y()
	var input = direction.normalized()
	#last_direction = character_body_2d.velocity.normalized()
	#Animation_Tree.set("parameters/Idle_BlendSpace2D/blend_position",input)
	
	character_body_2d.move_and_slide()
	#Transitions
	if direction_x or direction_y :
		transition.emit("Walk")
		
	if direction_x and GameInputEvents.shift_input():
		transition.emit("Run")
	
func enter():
	direction.x = GameInputEvents.movement_input()
	direction.y = GameInputEvents.movement_input_y()
	
	var input = direction.normalized()
	#last_direction = character_body_2d.velocity.normalized()
	#Animation_Tree.set("parameters/Idle_BlendSpace2D/blend_position",input)
	
	character_body_2d.move_and_slide()
	
	
func exit():
	#animation_player.stop()
	pass
