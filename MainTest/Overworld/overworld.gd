extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Levels/Maps/castle/castle.tscn")
	pass # Replace with function body.


func _on_to_dungeon_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Levels/Maps/dungeon/dungeon_map.tscn")
	pass # Replace with function body.
