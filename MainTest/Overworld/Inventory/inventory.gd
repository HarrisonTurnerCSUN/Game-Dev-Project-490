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

func consume_health_potion() -> InventoryItem:
	var health_potion = preload("res://Overworld/Inventory/Items/lifepot.tres")

	for i in range(slots.size()):
		var slot = slots[i]
		if slot.item == health_potion and slot.amount > 0:
			slot.amount -= 1
			var item = slot.item
			if slot.amount == 0:
				slots[i] = InventorySlot.new()
			updated.emit()
			return item

	return null
	
func count(item: InventoryItem) -> int:
	var total = 0
	for slot in slots:
		if slot.item == item:
			total += slot.amount
	return total

func remove(item: InventoryItem, amount: int) -> void:
	for slot in slots:
		if slot.item == item:
			var to_remove = min(slot.amount, amount)
			slot.amount -= to_remove
			amount -= to_remove
			if slot.amount <= 0:
				slot.item = null
			if amount == 0:
				break
	updated.emit()

func insert_amount(item: InventoryItem, amount: int):
	var remaining = amount
	# Try to fill existing stacks
	for slot in slots:
		if slot.item == item and slot.amount < item.maxAmountPrStack:
			var space = item.maxAmountPrStack - slot.amount
			var to_add = min(space, remaining)
			slot.amount += to_add
			remaining -= to_add
			if remaining == 0:
				updated.emit()
				return
	
	# Add to empty slots
	for slot in slots:
		if slot.item == null:
			var to_add = min(item.maxAmountPrStack, remaining)
			slot.item = item
			slot.amount = to_add
			remaining -= to_add
			if remaining == 0:
				updated.emit()
				return
	
	# Still not fully inserted, emit anyway
	updated.emit()
