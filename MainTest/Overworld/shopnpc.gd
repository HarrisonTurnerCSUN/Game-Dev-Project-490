extends Area2D

@export var cost_item: InventoryItem
@export var reward_item: InventoryItem
@export var cost_amount: int = 5

var player_in_range = null

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

	# Set up trade popup visuals
	var layout = $TradePopup/TradeLayout
	var cost_icon = layout.get_node("CostIcon")
	var reward_icon = layout.get_node("RewardIcon")
	var label = layout.get_node("ArrowLabel")

	if cost_item and reward_item:
		cost_icon.texture = cost_item.texture
		reward_icon.texture = reward_item.texture
		label.text = "x%d →" % cost_amount

func _on_body_entered(body):
	if body.name.begins_with("Player"):
		player_in_range = body
		print("Player entered trade zone")

func _on_body_exited(body):
	if body == player_in_range:
		player_in_range = null
		print("Player exited trade zone")

func try_trade():
	if player_in_range and player_in_range.has_method("get_inventory"):
		var inventory = player_in_range.get_inventory()

		if inventory.count(cost_item) >= cost_amount:
			inventory.remove(cost_item, cost_amount)
			inventory.insert(reward_item)
			print("Purchase successful! Item added.")
		else:
			print("Not enough items!")
