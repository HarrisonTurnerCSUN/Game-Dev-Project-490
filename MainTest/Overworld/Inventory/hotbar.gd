extends HBoxContainer

@onready var inventory: Inventory = preload("res://Overworld/Inventory/Items/playerInventory.tres")
@onready var slots: Array = get_children()

var selected_index: int = 0  # ✅ Tracks the selected hotbar slot

func _ready() -> void:
	inventory.updated.connect(update)
	update()

func update() -> void:
	for i in range(slots.size()):
		var inventory_slot: InventorySlot = inventory.slots[i]
		slots[i].update_to_slot(inventory_slot)
		slots[i].set_highlight(i == selected_index)  # ✅ Now this will work!

# ✅ Detect key presses (1-6) to switch hotbar slots
func _input(event):
	if event is InputEventKey and event.pressed:
		var key_number = event.keycode - KEY_1  # ✅ Convert key 1-6 to index 0-5
		if key_number >= 0 and key_number < slots.size():
			selected_index = key_number
			update()  # ✅ Update hotbar to apply highlight
