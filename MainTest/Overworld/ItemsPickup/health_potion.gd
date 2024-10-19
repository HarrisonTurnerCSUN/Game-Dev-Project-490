extends Area2D

@export var item_name: String = "health_potion"  # Item's name
@export var quantity: int = 1  # How many potions

# Called when the player enters the collision area
func _on_Area2D_body_entered(body):
	if body is CharacterBody2D:  # Check if the player (or a CharacterBody2D) entered the area
		body.pickup_item(item_name, quantity)  # Call the player's method to add the item to inventory
		queue_free()  # Remove the health potion from the scene after it's picked up
