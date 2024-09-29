extends Node

@export var node_finite_state_machine_bat : NodeFiniteStateMachineBat


func _on_aggro_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		node_finite_state_machine_bat.transition_to("aggro")


func _on_aggro_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		node_finite_state_machine_bat.transition_to("idle")
