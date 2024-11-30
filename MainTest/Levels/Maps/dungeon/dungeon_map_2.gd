extends Node2D

@export var music : AudioStream
@onready var falling_1: Area2D = $falling1
@onready var respawning_1: Area2D = $respawning1
@onready var player: CharacterBody2D = $Player
@onready var falling_2: Area2D = $falling2
@onready var respawning_2: Area2D = $respawning2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(music)
	
	player = get_node("Player")
	
	respawning_1 = get_node("respawning1")
	var falling_1 = get_node("falling1")
	
	respawning_2= get_node("respawning2")
	var falling_2= get_node("falling2")
	
	if not falling_1.is_connected("body_entered", Callable(self, "_on_falling_body_entered")):
		falling_1.connect("body_entered", Callable(self, "_on_falling_body_entered"))
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_falling_1_body_entered(body):
	if body == player:
		player.global_position = respawning_1.global_position


func _on_falling_2_body_entered(body: Node2D) -> void:
	if body == player:
		player.global_position = respawning_2.global_position
