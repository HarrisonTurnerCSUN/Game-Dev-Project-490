extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var falling_1: Area2D = $falling1
@onready var respawning_1: Area2D = $respawning1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	player = get_node("Player")
	
	respawning_1 = get_node("respawning1")
	var falling_1 = get_node("falling1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_falling_1_body_entered(body: Node2D) -> void:
	if body == player:
		player.global_position = respawning_1.global_position
