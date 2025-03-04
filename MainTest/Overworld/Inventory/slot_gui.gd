extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer

@onready var inventory = preload("res://Overworld/Inventory/Items/playerInventory.tres")

var itemStackGui: ItemStackGui
var index: int

func insert(isg: ItemStackGui):
	itemStackGui = isg
	backgroundSprite.frame = 1
	container.add_child(itemStackGui)
	
	if !itemStackGui.inventorySlot || inventory.slots[index] == itemStackGui.inventorySlot:
		return
		
	inventory.insertSlot(index, itemStackGui.inventorySlot)

func takeItem():
	var item = itemStackGui
	inventory.removeSlot(itemStackGui.inventorySlot)
	container.remove_child(itemStackGui)
	itemStackGui = null
	backgroundSprite.frame = 0
	return item

func isEmpty():
	return !itemStackGui

# ✅ Highlight selected hotbar slot
func set_highlight(is_selected: bool):
	if is_selected:
		backgroundSprite.modulate = Color(1.0, 0.84, 0.0, 1.0) 
	else:
		backgroundSprite.modulate = Color(1, 1, 1, 1)  # ✅ Default color
