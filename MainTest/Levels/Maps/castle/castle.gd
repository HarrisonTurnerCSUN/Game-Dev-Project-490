extends Node2D

@export var player_node_path: NodePath
@export var respawn_area_path: NodePath
@onready var player: CharacterBody2D = $Player
@onready var respawn_area: Area2D = $respawning
@onready var falling_2: Area2D = $falling2
@onready var respawning_2: Area2D = $respawning2
@onready var falling_3: Area2D = $falling3
@onready var respawning_3: Area2D = $respawning3

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	
	respawn_area = get_node("respawning")
	var falling_area = get_node("falling")
	
	respawning_2 = get_node("respawning2")
	var falling_2 = get_node("falling2")
	
	respawning_3 = get_node("respawning3")
	var falling_3 = get_node("falling3")
	
	
	if not player:
		print("Player node not found!")
		return
	if not respawn_area:
		print("Respawn area node not found!")
		return
	if not falling_area.is_connected("body_entered", Callable(self, "_on_falling_body_entered")):
		falling_area.connect("body_entered", Callable(self, "_on_falling_body_entered"))
		
	if not falling_2.is_connected("body_entered", Callable(self, "_on_falling_2_body_entered")):
		falling_2.connect("body_entered", Callable(self, "_on_falling_2_body_entered"))
		
	if not falling_3.is_connected("body_entered", Callable(self, "_on_falling_3_body_entered")):
		falling_3.connect("body_entered", Callable(self, "_on_falling_3_body_entered"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_falling_body_entered(body):
	if body == player:
		player.global_position = respawn_area.global_position

func _on_falling_2_body_entered(body):
	if body == player:
		player.global_position = respawning_2.global_position


func _on_falling_3_body_entered(body):
	if body == player:
		player.global_position = respawning_3.global_position
