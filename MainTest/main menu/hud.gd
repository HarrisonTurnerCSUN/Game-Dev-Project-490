extends Control
class_name Hud

@export var stopwatch_label : Label
@export var  is_stopwatch_hidden : bool = false
var stopwatch : Stopwatch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stopwatch = get_tree().get_first_node_in_group("Stopwatch")
	if is_stopwatch_hidden:
		stopwatch_label.hide()
	print(stopwatch)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_stopwatch_hidden:
		stopwatch_label.hide()
	update_stopwatch()
	if get_tree().paused == true:
		$".".hide()
	elif get_tree().paused == false:
		$".".show()

func update_stopwatch():
	stopwatch_label.text = stopwatch.time_to_string()
