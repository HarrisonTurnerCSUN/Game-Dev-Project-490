extends Node2D

@onready var menu = $CanvasLayer/InGameMenu
@export var tilemaplayer : TileMapLayer
@export var player : CharacterBody2D
# Called when the node enters the scene tree for the first time.
var stopwatch : Stopwatch
func _ready() -> void:
	stopwatch = get_tree().get_first_node_in_group("Stopwatch")
	

func _process(delta: float) -> void:
	var player_tile_data = tilemaplayer.get_cell_tile_data(tilemaplayer.local_to_map(player.position))
	if player_tile_data:
		if player_tile_data.get_custom_data("Fluid"): 
			player.velocity.x = clamp(player.velocity.x, -100, 100)
			player.velocity.y = clamp(player.velocity.y, -400, 100)
		#if player_tile_data.get_custom_data("Slow"):
			#player.velocity.x = clamp(player.velocity.x, -100, 100)
			
	if stopwatch.time/60 >= 5:
		menu.flip_star3()
	
	if stopwatch.time/60 >= 10:
		menu.flip_star2()
	
	if stopwatch.time/60 >= 15:
		menu.flip_star1()
