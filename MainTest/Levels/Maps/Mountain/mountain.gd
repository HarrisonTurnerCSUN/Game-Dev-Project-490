extends Node2D

@onready var menu = $CanvasLayer/InGameMenu
@export var tilemaplayer : TileMapLayer
@export var player : CharacterBody2D
# Called when the node enters the scene tree for the first time.
var stopwatch : Stopwatch
func _ready() -> void:
	stopwatch = get_tree().get_first_node_in_group("Stopwatch")
	

func _process(delta: float) -> void:
	if stopwatch.time/60 >= 5:
		menu.flip_star3()
	
	if stopwatch.time/60 >= 10:
		menu.flip_star2()
	
	if stopwatch.time/60 >= 15:
		menu.flip_star1()
