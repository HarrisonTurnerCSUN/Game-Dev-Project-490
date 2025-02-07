extends Control  # Attach this script to your MainCardContainer

func _ready():
	_update_position()  # Call once initially
	get_tree().paused = true # Pause the game immediately

# Signal emitted when the UI is about to close
signal ui_closed

# Function to hide the UI and unpause the game
func hide_ui():
	hide()  # Make the UI invisible
	get_tree().paused = false  # Unpause the game
	emit_signal("ui_closed") # Emit the signal

func _update_position():
	var viewport_size = get_viewport().get_size()
	var x = viewport_size.x / 2 - size.x / 2  # Center horizontally
	x = round(.5 * x)
	var y = 60  # Offset from the top (adjust this value)
	position = Vector2(x, y)


func _on_reward_1_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
