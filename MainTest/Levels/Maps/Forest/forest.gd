extends Node2D

@onready var menu = $CanvasLayer/InGameMenu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tower_activation_body_entered(body: Node2D) -> void:
	menu.flip_star1()
	pass # Replace with function body.
