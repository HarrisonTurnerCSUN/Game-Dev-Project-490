extends Area2D


var entered = false
var can_process_input = true

func _ready():
	entered = false
	can_process_input = true

func _on_body_entered(_body):
	entered = true
	print("entered")
	#print("entered") just used to check if the player entered collision

func _on_body_exited(_body):
	entered = false
	print("exit")
	#print("exit") just used to check if the player is not in the collision

func _process(_delta):
	if can_process_input and entered == true:
		if Input.is_action_just_pressed("enter"):
			can_process_input = false
			get_tree().change_scene_to_file("res://Levels/dungeon/dungeon_map.tscn")
