extends Node2D

@export var music : AudioStream
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(music)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
