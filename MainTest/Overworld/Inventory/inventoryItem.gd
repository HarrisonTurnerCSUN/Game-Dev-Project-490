extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmountPrStack: int = 10

func use(user) -> bool:
	if name == "Coin":
		var inventory = user.get_inventory()
		var amount_to_remove = 10

		if inventory.count(self) >= amount_to_remove:
			inventory.remove(self, amount_to_remove)
			print("Used 10 coins!")
			return true
		else:
			print("Not enough coins.")
			return false

	return false
