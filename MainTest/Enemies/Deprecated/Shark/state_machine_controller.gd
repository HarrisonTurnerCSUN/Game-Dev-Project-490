extends Node

@export var node_finite_state_machine_squid : NodeFiniteStateMachineSquid



func _on_run_area_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		node_finite_state_machine_squid.transition_to("run")


func _on_run_area_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		node_finite_state_machine_squid.transition_to("idle")
		



func _on_attack_area_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		node_finite_state_machine_squid.transition_to("attack")


func _on_attack_area_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		node_finite_state_machine_squid.transition_to("idle")
