extends Area2D

var entered

func _ready():
	entered = false


func _on_body_entered(_body):
	entered = true
	#print("entered") just used to check if the player entered collision

func _on_body_exited(_body):
	entered = false
	#print("exit") just used to check if the player is not in the collision

func _process(_delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file("res://Levels/dungeon/dungeon_map.tscn")
