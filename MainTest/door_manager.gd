extends Node2D

var entered_door = ""  # Variable to track which door the player is near

func _ready():
	entered_door = ""  # Initialize variable

# Function to handle when the player enters the right door
func _on_RightDoor_body_entered(_body):
	if _body.name == "Player":  # Ensure it's the player entering
		if entered_door == "":
			entered_door = "right"
			print("Entered Right Door")

# Function to handle when the player exits the right door
func _on_RightDoor_body_exited(_body):
	if _body.name == "Player":  # Ensure it's the player exiting
		if entered_door == "right":
			entered_door = ""
			print("Exited Right Door")

# Function to handle when the player enters the left door
func _on_LeftDoor_body_entered(_body):
	if _body.name == "Player":  # Ensure it's the player entering
		if entered_door == "":
			entered_door = "left"
			print("Entered Left Door")

# Function to handle when the player exits the left door
func _on_LeftDoor_body_exited(_body):
	if _body.name == "Player":  # Ensure it's the player exiting
		if entered_door == "left":
			entered_door = ""
			print("Exited Left Door")

# Process input when near a door
func _process(_delta):
	if entered_door != "" and Input.is_action_just_pressed("ui_accept"):
		if entered_door == "right":
			print("Going to Dungeon 2")
			get_tree().change_scene_to_file("res://dungeon_map_2.tscn")
		elif entered_door == "left":
			print("Going to Dungeon 3")
			get_tree().change_scene_to_file("res://dungeon_map_3.tscn")
