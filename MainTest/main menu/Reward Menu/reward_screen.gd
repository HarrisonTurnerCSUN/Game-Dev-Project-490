extends Control  # Attach this script to your MainCardContainer

class_name Item

#signal ui_closed

var Item = preload("res://main menu/Reward Menu/Item.tscn")

func _ready():
	_update_position()  # Call once initially
	get_tree().paused = true # Pause the game immediately
	generate_rewards()
	
func generate_rewards():
	var item_pool = []
	item_pool = ["antidote_potion","curse_potion", "wind_potion", "fire_potion"]
	for card in [$RewardBase, $RewardBase2, $RewardBase3]:
		item_pool.shuffle()
		var item_id = item_pool[0]
		var item_data = generate_item_data(item_id)
		var item = card.get_node("Item")
		
		item.item_id = item_data.item_id
		
		card.item = item
		card.title = item_data.title
		card.description = item_data.description
		card.connect("select_reward", _on_select_reward)
		item_pool.remove_at(0)
		
func _on_select_reward(reward_card):
	SaveController.addPotion(reward_card.title)
	hide_ui()

# Function to hide the UI and unpause the game
func hide_ui():
	get_tree().paused = false  # Unpause the game
	get_parent().queue_free()
	#emit_signal("ui_closed") # Emit the signal

func _exit_tree():
	get_tree().paused = false  # ✅ Ensure game unpauses when UI is removed
	
func _update_position():
	var viewport_size = get_viewport().get_size()
	var x = viewport_size.x / 2 - size.x / 2  # Center horizontally
	#x = round(.5 * x)
	var y = 60  # Offset from the top (adjust this value)
	position = Vector2(x, y)

func generate_item_data(item_id):
	var item_data = {}
	
	item_data.item_id = item_id
	item_data.title = "Title"
	item_data.description = "placeholder"
	
	match item_id:
		"antidote_potion":
			item_data.title = "Elixir of Stamina"
			item_data.description = "Stamina +2"
		"curse_potion":
			item_data.title = "Elixir of Fortitude"
			item_data.description = "Health +1"
		"wind_potion":
			item_data.title = "Elixir of Swiftness"
			item_data.description = "Speed +10%"
		"fire_potion":
			item_data.title = "Elixir of Strength"
			item_data.description = "Damage +1"
		_:
			item_data.title = str(item_id).capitalize()
			print("Unmatched item_id: ", item_id)
	
	return item_data
