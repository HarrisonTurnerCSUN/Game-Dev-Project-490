extends Control

@export_category("Popup info")
@export var text : String
@export var destination : String = "Main Menu"
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass



func _on_yes_pressed() -> void:
	if destination == "Main Menu":
		get_tree().paused = false
		get_tree().change_scene_to_file("res://main menu/menu.tscn")
		SaveController.saveGame();
	elif destination == "Quit":
		SaveController.saveGame();
		get_tree().quit()


func _on_no_pressed() -> void:
	$".".hide()
