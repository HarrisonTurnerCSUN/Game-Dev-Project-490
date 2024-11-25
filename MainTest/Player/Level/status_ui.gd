extends CanvasLayer

# Health textures
@export var full_heart_texture: Texture2D
@export var half_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D
@export var max_health: int = 10  # Max health

# Stamina textures
@export var stamina_bar_bg_texture: Texture2D
@export var stamina_20_texture: Texture2D
@export var stamina_40_texture: Texture2D
@export var stamina_60_texture: Texture2D
@export var stamina_80_texture: Texture2D
@export var stamina_100_texture: Texture2D
@export var max_stamina: int = 100  # Max stamina

# Variables for health and stamina
var health_tiles: Array[TextureRect] = []
var stamina_bar_left: TextureRect
var stamina_bar_middle: TextureRect
var stamina_bar_right: TextureRect
var stamina_container: HBoxContainer

@onready var health: Health = $"../../Health"
@onready var stamina: Stamina = $"../../Stamina"

func _ready() -> void:
	var vbox = $VBoxContainer  # Adjust the path to your container
	vbox.anchor_left = 0.0
	vbox.anchor_right = 1.0
	vbox.anchor_top = 0.0
	vbox.anchor_bottom = 1.0

	# Health and stamina will now align vertically
	_create_health_tiles(vbox.get_node("HealthBar"), health_tiles, full_heart_texture, half_heart_texture, empty_heart_texture)
	_create_stamina_bar(vbox.get_node("StaminaBar"))

	# Connect signals from Health and Stamina nodes to the update functions
	health.connect("damaged", Callable(self, "_on_health_changed"))
	stamina.connect("stamina_used", Callable(self, "_on_stamina_changed"))

# Create health tiles (full, half, empty hearts)
func _create_health_tiles(container: Node, tile_array: Array[TextureRect], full_heart: Texture2D, half_heart: Texture2D, empty_heart: Texture2D) -> void:
	for i in range(max_health / 2):  # 5 full hearts for max 10 health
		var tile = TextureRect.new()
		tile.texture = full_heart  # Default to full heart
		tile.modulate = Color(1, 1, 1, 1)  # Make sure it's visible
		container.add_child(tile)
		tile_array.append(tile)

# Create stamina bar (using HBoxContainer for alignment)
func _create_stamina_bar(container: Node) -> void:
	# Create HBoxContainer to hold the left, middle, and right parts of the stamina bar
	stamina_container = HBoxContainer.new()
	#stamina_container.rect_min_size = Vector2(max_stamina, 40)  # Set a fixed height for the stamina bar container
	container.add_child(stamina_container)

	# Left part (this will be fixed width)
	stamina_bar_left = TextureRect.new()
	stamina_bar_left.texture = stamina_20_texture
	stamina_bar_left.stretch_mode = TextureRect.STRETCH_SCALE
	stamina_container.add_child(stamina_bar_left)

	# Middle part (this will be stretched based on stamina)
	stamina_bar_middle = TextureRect.new()
	stamina_bar_middle.texture = stamina_40_texture
	stamina_bar_middle.stretch_mode = TextureRect.STRETCH_SCALE
	stamina_container.add_child(stamina_bar_middle)

	# Right part (this will be fixed width and will hide when not needed)
	stamina_bar_right = TextureRect.new()
	stamina_bar_right.texture = stamina_100_texture
	stamina_bar_right.stretch_mode = TextureRect.STRETCH_SCALE
	stamina_container.add_child(stamina_bar_right)

# Update health (using full, half, and empty hearts)
func update_health(current_health: int) -> void:
	var full_hearts = current_health / 2
	var half_hearts = (current_health % 2) / 1
	var empty_hearts = (max_health / 2) - full_hearts - half_hearts

	for i in range(health_tiles.size()):
		if i < full_hearts:
			health_tiles[i].texture = full_heart_texture
		elif i < full_hearts + half_hearts:
			health_tiles[i].texture = half_heart_texture
		else:
			health_tiles[i].texture = empty_heart_texture
		health_tiles[i].modulate = Color(1, 1, 1, 1)

# Update stamina bar (left, middle, right textures with dynamic width and visibility)
func update_stamina(current_stamina: float) -> void:
	# Calculate the stamina percentage
	var fill_percentage = current_stamina / max_stamina

	# Set fixed width for the left texture
	stamina_bar_left.rect_min_size.x = 20  # Set the width for the left part (fixed)

	# Set the width of the middle texture based on stamina
	var middle_width = int(fill_percentage * (max_stamina - 40))  # Subtract space for left and right parts
	stamina_bar_middle.rect_min_size.x = middle_width

	# Set the visibility and width of the right texture
	if fill_percentage >= 0.8:
		stamina_bar_right.rect_min_size.x = int((fill_percentage - 0.8) * max_stamina)
		stamina_bar_right.visible = true
	else:
		stamina_bar_right.rect_min_size.x = 0
		stamina_bar_right.visible = false

# Signal handlers for health and stamina changes
func _on_health_changed(amount: float, knockback: Vector2) -> void:
	update_health(health.get_current())

func _on_stamina_changed(amount: float) -> void:
	update_stamina(stamina.get_current_stamina())
