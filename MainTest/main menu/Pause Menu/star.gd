extends TextureRect

@export var complete : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_complete()
	
func check_complete() -> void:
	if complete:
		set_modulate("ffff00")
	else: 
		set_modulate("ffffff")
