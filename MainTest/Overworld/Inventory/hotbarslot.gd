extends Button 

@onready var background_sprite: Sprite2D = $background
@onready var item_stack_gui: ItemStackGui = $CenterContainer/Panel

func update_to_slot(slot: InventorySlot) -> void:
	if !slot.item:
		item_stack_gui.visible = false
		background_sprite.frame = 0
		return
		
	item_stack_gui.inventorySlot = slot
	item_stack_gui.update()
	item_stack_gui.visible = true
	
	background_sprite.frame = 1

# ✅ Add this function to highlight the selected hotbar slot
func set_highlight(is_selected: bool):
	if is_selected:
		background_sprite.modulate = Color(1.0, 0.84, 0.0, 1.0)  # ✅ Gold Highlight
	else:
		background_sprite.modulate = Color(1, 1, 1, 1)  # ✅ Default white
