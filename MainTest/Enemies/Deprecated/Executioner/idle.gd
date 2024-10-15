extends NodeState

@export var character_body_2d : CharacterBody2D
@export var slow_down_speed : int = 50
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func on_process(_delta :float):
	pass
	
func on_physics_process(delta :float):
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, slow_down_speed * delta)
	animation_player.play("Idle")
	character_body_2d.move_and_slide()
	
func enter():
	pass
	
func exit():
	pass


func _on_aggro_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		transition.emit("Aggro")
