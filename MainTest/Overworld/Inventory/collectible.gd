extends Area2D

@export var itemRes: InventoryItem
@export var amount: int = 1 

func collect(inventory: Inventory):
	for i in range(amount):
		inventory.insert(itemRes)
	queue_free()
