extends Node2D

var entered_door = ""  # Variable to track which door the player is near
var left_door_locked = true
var can_process_input = true  # Control input processing


func _ready():
	entered_door = ""  # Initialize variable
	left_door_locked = true
	can_process_input = true  # Allow input initially
	print("Door Manager Ready - All doors initialized")

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
		if left_door_locked:
			if KeyManager.has_key:
				unlock_left_door()
				entered_door = "left"
			else:
				print("Left door is locked. you need a key")
		else: 
			entered_door = "left"
			print("Entered Left Door")

func unlock_left_door():
	left_door_locked = false
	print("the left door is now unlocked")

# Function to handle when the player exits the left door
func _on_LeftDoor_body_exited(_body):
	if _body.name == "Player":  # Ensure it's the player exiting
		if entered_door == "left":
			entered_door = ""
			print("Exited Left Door")

# Process input when near a door
func _process(_delta):
	if can_process_input and Input.is_action_just_pressed("enter"):
		can_process_input = false
		print("Player pressed the accept button near door: ", entered_door)
		if entered_door == "right":
			print("Going to Dungeon 2")
			change_scene_and_cleanup("res://Levels/dungeon/dungeon_map_2.tscn")

		elif entered_door == "left":
			print("Going to Dungeon 3")
			change_scene_and_cleanup("res://Levels/dungeon/dungeon_map_3.tscn")

		elif entered_door == "dungeon2_to_main":
			print("Returning to Main Dungeon from Dungeon 2")
			change_scene_and_cleanup("res://Levels/dungeon/dungeon_map.tscn")  # Dungeon 2 door to Main Dungeon

		elif entered_door == "dungeon3_to_main":
			print("Returning to Main Dungeon from Dungeon 3")
			change_scene_and_cleanup("res://Levels/dungeon/dungeon_map.tscn")  # Dungeon 3 door to Main Dungeon



func change_scene_and_cleanup(new_scene):
	print("Changing scene to: ", new_scene)
	entered_door = ""  # Clear the entered_door variable to prevent unintended triggers
	get_tree().change_scene_to_file(new_scene)
	can_process_input = true  # Re-enable input after scene change
