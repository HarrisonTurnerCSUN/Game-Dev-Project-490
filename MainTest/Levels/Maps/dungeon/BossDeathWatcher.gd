extends Node

@export var watchedEnemy : CharacterBody2D
@export var menu : Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var call = Callable(menu,"_set_is_complete")
	watchedEnemy.connect("death",call)
	
	
