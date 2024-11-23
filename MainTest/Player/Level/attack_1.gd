extends NodeState
@onready var timer: Timer = $"../../Timer"
@export var character_body_2d : CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"
@export var friction : int = 500
@export_category("Attack1 state")


func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x,0,friction)
	
	character_body_2d.move_and_slide()
	
	#Transitions


	
func enter():
	#timer.start()
	animation_player.play("Attack1")
	await animation_player.animation_finished
	transition.emit("Idle")
	
func exit():
	pass


func _on_timer_timeout() -> void:
	#transition.emit("Idle")
	pass
