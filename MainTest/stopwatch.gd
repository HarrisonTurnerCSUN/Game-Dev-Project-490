extends Node
class_name Stopwatch

var time = 0.0
var stopped = false




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stopped:
		return
	time += delta
	
func reset():
	time = 0.0
	
func time_to_string() -> String:
	var sec = fmod(time, 60)
	var min = time/60
	var str_format = "%02d:%02d"
	var str_output =  str_format % [min, sec]
	return str_output
