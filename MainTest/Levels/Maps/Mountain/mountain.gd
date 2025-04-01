extends Node2D

@onready var menu = $CanvasLayer/InGameMenu
@export var tilemaplayer : TileMapLayer
@export var player : CharacterBody2D
# Called when the node enters the scene tree for the first time.
var stopwatch : Stopwatch
func _ready() -> void:
	stopwatch = get_tree().get_first_node_in_group("Stopwatch")
	menu.flip_star1()
	menu.flip_star2()
	

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
	
	
	


func _on_star_area_2d_body_entered(body: Node2D, starId: int) -> void:
	if starId == 1:
		menu.flip_star1()
	elif starId == 2:
		print("?")
		menu.flip_star2()


func _on_stone_door_trigger_1_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
