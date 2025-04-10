extends Node



var last_position := Vector2.ZERO
var last_exit_door := ""

func persist_position(position: Vector2, right_door: String):
	last_position = position
	last_exit_door = right_door
	print("Persisted Position: ", last_position, " From Door: ", right_door)
