extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_attack_1_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free()
	print("x")
	
func _on_attack_1_area_2d_body_exited(body: Node2D) -> void:
	pass

#func receives_knockback(damage_source_pos: Vector2, received_damage: int):
	#pass
