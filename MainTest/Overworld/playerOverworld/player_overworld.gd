extends CharacterBody2D

@onready var animation_player = $AnimatedSprite2D
@export var inventory : Dictionary = {}  # The player's inventory

# Player script (overworldplayer.gd)
func pickup_item(item_name: String, quantity: int = 1):
	if inventory.has(item_name):
		inventory[item_name] += quantity
	else:
		inventory[item_name] = quantity
	
	print("Picked up: " + item_name + " x" + str(quantity))
# Update the inventory in the inventory UI

	var inventory_ui = $Control  # Access the Control node under the Playerth to your inventory UI node
	inventory_ui.add_item(item_name, quantity)
