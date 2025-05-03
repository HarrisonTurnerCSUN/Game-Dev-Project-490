extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]


func insert(item: InventoryItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item and slot.amount < item.maxAmountPrStack)
	
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
		updated.emit()
		return
	
	var emptySlots = slots.filter(func(slot): return slot.item == null)
	if !emptySlots.is_empty():
		emptySlots[0].item = item
		emptySlots[0].amount = 1
		updated.emit()


func removeSlot(inventorySlot: InventorySlot):
	var index = slots.find(inventorySlot)
	if index < 0: return
	
	slots[index] = InventorySlot.new()
	updated.emit()

func insertSlot(index: int, inventorySlot: InventorySlot):
	slots[index] = inventorySlot
	updated.emit()
	
func has_items() -> bool:
	for slot in slots:
		if slot.item != null and slot.amount > 0:
			return true
	return false

func consume_first_item() -> InventoryItem:
	for i in range(slots.size()):
		var slot = slots[i]
		if slot.item != null and slot.amount > 0:
			slot.amount -= 1
			var item = slot.item
			if slot.amount == 0:
				slots[i] = InventorySlot.new()
			updated.emit()
			return item
	return null  # No item found
