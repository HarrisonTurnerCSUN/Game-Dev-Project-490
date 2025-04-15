extends Node2D

@onready var menu = $CanvasLayer/InGameMenu
@export var tilemaplayer : TileMapLayer
@export var player : CharacterBody2D

var current_wave: int
var starting_nodes: int
var current_nodes: int
var wave_spawning: bool
var wave_transitioning: bool

@export var bat_scene: PackedScene
@export var goblin_scene: PackedScene
@export var wolf_scene: PackedScene
@export var witch_scene: PackedScene
@export var worm_scene: PackedScene
@export var eyeball_scene: PackedScene
# Called when the node enters the scene tree for the first time.
var stopwatch : Stopwatch
func _ready() -> void:
	stopwatch = get_tree().get_first_node_in_group("Stopwatch")
	current_wave = 0
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	#menu.flip_star1()
	#menu.flip_star2()
	

func _process(delta: float) -> void:
	#var player_tile_data = tilemaplayer.get_cell_tile_data(tilemaplayer.local_to_map(player.position))
	#if player_tile_data:
		#if player_tile_data.get_custom_data("Fluid"): 
			#player.velocity.x = clamp(player.velocity.x, -100, 100)
			#player.velocity.y = clamp(player.velocity.y, -400, 100)
		#if player_tile_data.get_custom_data("Slow"):
			#player.velocity.x = clamp(player.velocity.x, -100, 100)
			
	if stopwatch.time/60 >= 5:
		menu.flip_star3()
		
	if stopwatch.time/60 >= 10:
		menu.flip_star2()
	
	if stopwatch.time/60 >= 15:
		menu.flip_star1()

	
func _to_next_wave() ->void:
	if current_nodes == starting_nodes:
		current_wave += 1
