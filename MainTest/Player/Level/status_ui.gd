extends CanvasLayer

@export var full_heart_texture: Texture2D
@export var half_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D
@export var max_health: int = 10  # Max health

@export var stamina_bar_bg_texture: Texture2D
@export var stamina_left_texture: Texture2D
@export var stamina_middle_texture: Texture2D
@export var stamina_right_texture: Texture2D
@export var max_stamina: int = 100  # Max stamina

var health_tiles: Array[TextureRect] = []
var stamina_bar_bg: TextureRect
var stamina_bar_left: TextureRect
var stamina_bar_middle_1: TextureRect
var stamina_bar_middle_2: TextureRect
var stamina_bar_middle_3: TextureRect
var stamina_bar_middle_4: TextureRect
var stamina_bar_middle_5: TextureRect
var stamina_bar_right: TextureRect
var hbox: HBoxContainer

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

# Create stamina bar (background and foreground)
func _create_stamina_bar(container: Node) -> void:
	# Background
	stamina_bar_bg = TextureRect.new()
	stamina_bar_bg.texture = stamina_bar_bg_texture
	stamina_bar_bg.stretch_mode = TextureRect.STRETCH_SCALE
	container.add_child(stamina_bar_bg)

	# Create HBoxContainer to handle the horizontal layout
	hbox = HBoxContainer.new()
	#hbox.separation = 0  # Remove spacing between the foreground pieces
	container.add_child(hbox)

	# Left part of the foreground
	stamina_bar_left = TextureRect.new()
	stamina_bar_left.texture = stamina_left_texture
	stamina_bar_left.stretch_mode = TextureRect.STRETCH_SCALE
	hbox.add_child(stamina_bar_left)

	# Middle parts of the foreground (now we have 5 middle pieces)
	stamina_bar_middle_1 = TextureRect.new()
	stamina_bar_middle_1.texture = stamina_middle_texture
	stamina_bar_middle_1.stretch_mode = TextureRect.STRETCH_SCALE
	hbox.add_child(stamina_bar_middle_1)

	stamina_bar_middle_2 = TextureRect.new()
	stamina_bar_middle_2.texture = stamina_middle_texture
	stamina_bar_middle_2.stretch_mode = TextureRect.STRETCH_SCALE
	hbox.add_child(stamina_bar_middle_2)

	stamina_bar_middle_3 = TextureRect.new()
	stamina_bar_middle_3.texture = stamina_middle_texture
	stamina_bar_middle_3.stretch_mode = TextureRect.STRETCH_SCALE
	hbox.add_child(stamina_bar_middle_3)

	stamina_bar_middle_4 = TextureRect.new()
	stamina_bar_middle_4.texture = stamina_middle_texture
	stamina_bar_middle_4.stretch_mode = TextureRect.STRETCH_SCALE
	hbox.add_child(stamina_bar_middle_4)

	stamina_bar_middle_5 = TextureRect.new()
	stamina_bar_middle_5.texture = stamina_middle_texture
	stamina_bar_middle_5.stretch_mode = TextureRect.STRETCH_SCALE
	hbox.add_child(stamina_bar_middle_5)

	# Right part of the foreground
	stamina_bar_right = TextureRect.new()
	stamina_bar_right.texture = stamina_right_texture
	stamina_bar_right.stretch_mode = TextureRect.STRETCH_SCALE
	hbox.add_child(stamina_bar_right)

	# Make sure the foreground is above the background
	stamina_bar_bg.z_index = 0
	hbox.z_index = 1

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

# Update stamina bar (use different textures for different percentages)
func update_stamina(current_stamina: float) -> void:
	var fill_percentage = current_stamina / max_stamina

	# Show left texture if there's any stamina
	stamina_bar_left.visible = fill_percentage > 0

	# Show right texture if stamina is more than 80%
	stamina_bar_right.visible = fill_percentage > 0.8

	# Determine the number of middle textures to show based on the stamina percentage
	var middle_count = max(0, int((fill_percentage - 0.2) * 5))  # For the 5 middle textures

	# Set visibility based on middle_count
	stamina_bar_middle_1.visible = middle_count >= 1
	stamina_bar_middle_2.visible = middle_count >= 2
	stamina_bar_middle_3.visible = middle_count >= 3
	stamina_bar_middle_4.visible = middle_count >= 4
	stamina_bar_middle_5.visible = middle_count >= 5

	# Make sure that the middle textures only show up when the percentage is > 0.2
	# If it's 0, hide all the middle parts
	if fill_percentage == 0:
		stamina_bar_middle_1.visible = false
		stamina_bar_middle_2.visible = false
		stamina_bar_middle_3.visible = false
		stamina_bar_middle_4.visible = false
		stamina_bar_middle_5.visible = false
		stamina_bar_left.visible = false  # Hide the left part as well when stamina is zero

# Signal handlers for health and stamina changes
func _on_health_changed(amount: float, knockback: Vector2) -> void:
	update_health(health.get_current())

func _on_stamina_changed(amount: float) -> void:
	update_stamina(stamina.get_current_stamina())
