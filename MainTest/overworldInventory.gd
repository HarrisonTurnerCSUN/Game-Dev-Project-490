extends Control

# Inventory to hold items and their quantities
@export var inventory : Dictionary = {}

# Array to store the texture buttons dynamically
@export var inventory_buttons : Array = []

func _ready():
	# Find all the TextureButtons inside the GridContainer and store them in inventory_buttons
	var grid_container = $Panel/GridContainer  # Adjust this path if needed
	for button in grid_container.get_children():
		inventory_buttons.append(button)

	#Test item pickups
	test_inventory()
	update_inventory_ui()
	
	# Detect input for toggling the inventory UI
func _input(event):
	if event.is_action_pressed("ui_inventory"):
		toggle_inventory()

# Function to toggle the visibility of the inventory panel
func toggle_inventory():
	var panel = $Panel
	panel.visible = not panel.visible

func test_inventory():
	# Simulate adding items to the inventory for testing
	add_item("Next", 1)  # Adds 2 potions to the inventory
	add_item("Play", 1)   # Adds 1 sword to the inventory
	add_item("Previous", 1)  # Adds 1 shield to the inventory
	add_item("Fall", 1)

# Function to add items to the inventory
func add_item(item_name: String, quantity: int = 1):
	if inventory.has(item_name):
		inventory[item_name] += quantity  # If the item exists, increase its quantity
	else:
		inventory[item_name] = quantity  # Otherwise, add the new item

	update_inventory_ui()  # Update the UI when the inventory changes

# Function to update the inventory UI
func update_inventory_ui():
	for button in inventory_buttons:
		# Reset the item texture (not the button background)
		var item_texture_rect = button.get_node("TextureRect")
		item_texture_rect.texture = null  # Clear previous item textures
	
	var index = 0
	for item_name in inventory.keys():
		if index >= inventory_buttons.size():
			break  # Stop if more items than available slots
		
		var button = inventory_buttons[index]
		var item_texture_rect = button.get_node("TextureRect")

		# Set the item texture (keeping the background intact)
		var texture_path = "res://Items/Menu/Buttons/" + item_name + ".png"
		item_texture_rect.texture = load(texture_path)  # Set the item texture here
		
		index += 1
