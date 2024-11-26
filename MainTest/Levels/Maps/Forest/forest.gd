extends Node2D

@onready var menu = $CanvasLayer/InGameMenu
@export var tilemaplayer : TileMapLayer
@export var player : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_tile_data = tilemaplayer.get_cell_tile_data(tilemaplayer.local_to_map(player.position))
	if player_tile_data:
		if player_tile_data.get_custom_data("Fluid"): 
			player.velocity -= delta*100*player.velocity
	pass


func _on_tower_activation_body_entered(body: Node2D) -> void:
	menu.flip_star1()
	pass # Replace with function body.
