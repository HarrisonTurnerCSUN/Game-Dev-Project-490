extends Node2D

@onready var sceneChangeAnim = $CanvasLayer/SceneTransition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$YSORT/PlayerOverworld.position = Vector2(SaveController.getOverworldPositionX(),SaveController.getOverworldPositionY())
	sceneChangeAnim.play("fadeOut")
	await sceneChangeAnim.animation_finished
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	var sign = $Sign2
	SaveController.setOverworldPositionX(sign.global_position.x)
	SaveController.setOverworldPositionY(sign.global_position.y)
	get_tree().change_scene_to_file("res://Levels/Maps/castle/castle.tscn")
	pass # Replace with function body.


func _on_to_dungeon_body_entered(body: Node2D) -> void:
	var sign = $Sign
	SaveController.setOverworldPositionX(sign.global_position.x)
	SaveController.setOverworldPositionY(sign.global_position.y)
	get_tree().change_scene_to_file("res://Levels/Maps/dungeon/dungeon_map.tscn")
	pass # Replace with function body.


func _on_to_goblin_body_entered(body: Node2D) -> void:
	var sign = $Sign5
	SaveController.setOverworldPositionX(sign.global_position.x)
	SaveController.setOverworldPositionY(sign.global_position.y)
	get_tree().change_scene_to_file("res://Levels/Maps/Goblin Camp/goblin_camp.tscn")
	pass # Replace with function body.


func _on_to_mountain_body_entered(body: Node2D) -> void:
	var sign = $Sign6
	SaveController.setOverworldPositionX(sign.global_position.x)
	SaveController.setOverworldPositionY(sign.global_position.y)
	get_tree().change_scene_to_file("res://Levels/Maps/Mountain/mountain.tscn")
	pass # Replace with function body.
	
func _on_to_forest_body_entered(body: Node2D) -> void:
	var sign = $Sign3
	SaveController.setOverworldPositionX(sign.global_position.x)
	SaveController.setOverworldPositionY(sign.global_position.y)
	get_tree().change_scene_to_file("res://Levels/Maps/Forest/forest.tscn")
	pass
	
func _on_to_desert_body_entered(body: Node2D) -> void:
	var sign = $Sign4
	SaveController.setOverworldPositionX(sign.global_position.x)
	SaveController.setOverworldPositionY(sign.global_position.y)
	get_tree().change_scene_to_file("res://Levels/Maps/Desert/desert.tscn")
	pass
