extends Control

var item_id = "item_id" : set = set_item_id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_item_id(new_item_id):
	item_id = new_item_id
	var sprite_path = "res://Assets/Items/PotionAssets/%s.png" % [item_id]
	$itemSprite.texture = load(sprite_path)
