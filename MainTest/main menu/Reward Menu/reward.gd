extends Control

signal select_reward

@onready var hover_layer: TileMapLayer = $TileMapLayer/HoverLayer
@onready var audio_hover: AudioStreamPlayer2D = $AudioHover
@onready var audio_select: AudioStreamPlayer2D = $AudioSelect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)  # Enable input processing
	mouse_filter = Control.MOUSE_FILTER_STOP  # Ensure the node receives inputdy.
	hover_layer.visible = false  # Hide initially
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if Input.is_action_pressed("left_click"):
			emit_signal("select_reward", self)
			audio_select.play()
			var canvas_layer = find_parent_canvas_layer()
			get_tree().paused = false
			if canvas_layer:
				canvas_layer.hide()

# 🔍 Helper function to find the CanvasLayer
func find_parent_canvas_layer() -> CanvasLayer:
	var parent = get_parent()
	while parent:
		if parent is CanvasLayer:
			return parent
		parent = parent.get_parent()
	return null  # Return null if no CanvasLayer is found

func _on_mouse_entered() -> void:
	hover_layer.visible = true  # Show hover layer
	audio_hover.play()

func _on_mouse_exited() -> void:
	hover_layer.visible = false  # Hide initially
