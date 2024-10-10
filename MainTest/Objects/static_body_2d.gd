extends StaticBody2D

var is_open = false  
var key_grabbed = false
var player_near_key = false

# @onready variables for referencing nodes
@onready var animated_sprite = $AnimatedSprite2D
@onready var key_sprite = $Area2D2/key  # Path to the key under Area2D2
@onready var chest_area = $Area2D  # Chest interaction area
@onready var key_area = $Area2D2  # Key pickup area

# Function runs when the scene is loaded
func _ready():
	key_sprite.visible = false  # Hide the key initially
	

	if not animated_sprite:
		print("Error: Could not find AnimatedSprite2D!")
	else:
		print("Success: Found AnimatedSprite2D!")

# Function to open the chest
func open_chest():
	if not is_open:
		animated_sprite.play("open")  # Play the chest opening animation
		is_open = true

# Toggle chest state (currently only opens)
func toggle_chest():
	if not is_open:
		open_chest()

# Interaction function to open the chest
func _on_interact():
	toggle_chest()

# Detect when the player enters the chest interaction area
func _on_area_2d_body_entered(body):
	if body.name == "Player":  # Check if the body is the player
		set_process(true)  # Start processing input for interactions

# Detect when the player enters the key area
func _on_area_2d_2_body_entered(body):
	if body.name == "Player":
		player_near_key = true
		print("Player is near the key. Press 'interact' to grab it.")
	else:
		print("Another body entered the key area: ", body.name)  # Debug other bodies entering the key area

# Detect player interactions for chest and key
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		print("Interact key pressed")  # Debug input detection
		_on_interact()

		if player_near_key and not key_grabbed:
			grab_key()

# Function to handle grabbing the key
func grab_key():
	key_grabbed = true  # Mark the key as grabbed
	key_sprite.visible = false  # Hide the key to simulate it being picked up
	print("Player grabbed the key!")

# Function to show the key when the chest opens
func show_key():
	if key_sprite:
		# Set the key's position relative to the chest, e.g., drop it to the left
		var drop_offset = Vector2(-15, 0)  # Offset to the left by 50 pixels
		key_sprite.position = key_sprite.position + drop_offset  # Move key left
		key_sprite.visible = true  # Make the key visible
		
		# Optional: Simulate the key falling down a bit
		# Drop the key slightly down by adjusting the y-position
		key_sprite.position.y += 5  # You can adjust the value to make the key drop lower
		
		print("Key has dropped to the left of the chest and is now visible!")
	else:
		print("Error: Key sprite not found!")  # Debug if key sprite isn't found

# Handle animation completion and show the key
func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "open":
		animated_sprite.stop()  # Stop the animation once it's finished
		show_key()  # Show the key after the chest opens
		print("Chest animation finished.")
