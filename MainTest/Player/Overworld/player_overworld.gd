extends CharacterBody2D

@onready var animation_player = $AnimatedSprite2D
# Example in the Player script or item pickup logic
func on_item_pickup(item_name: String):
	$Control.add_item(item_name, 1)  # This will add 1 of the specified item to the inventory
