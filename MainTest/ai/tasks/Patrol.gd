@tool
extends BTAction
## Enhanced patrol task: handles wall collisions and basic movement.

@export var patrol_range: float = 200.0  # Default patrol range left/right
@export var retreat_range: float = 300.0  # Distance to move when turning around at a wall
@export var speed_var: StringName = &"speed"  # Blackboard key for patrol speed

const TOLERANCE := 10.0  # Distance threshold for reaching a point
var _target_point: Vector2  # Current target point
var _moving_toward_wall: bool = false  # Whether the agent is currently avoiding a wall
var _last_direction_right: bool = true  # Last direction (true = right, false = left)


# Generate a descriptive name for the task.
func _generate_name() -> String:
	return "Dynamic Patrol with Wall Handling"


# Initialize patrol state and target point.
func _enter() -> void:
	if _target_point == null:  # Initialize only if unset
		_set_new_patrol_points()


# Main patrol logic.
func _tick(_delta: float) -> Status:
	# Check if the target is within 140 units
	var target = blackboard.get_var("target", null)
	if is_instance_valid(target):
		if agent.global_position.distance_to(target.global_position) <= 140.0:
			return FAILURE  # Interrupt patrol to allow higher-priority tasks

	# Wall detection
	if agent.is_on_wall():  # If hitting a wall, reverse direction
		_reverse_patrol_direction()

	# Normal patrol logic
	if agent.global_position.distance_to(_target_point) < TOLERANCE:
		_set_new_patrol_points()  # Set new patrol points

	# Move toward the current target point
	var speed: float = blackboard.get_var(speed_var, 100.0)
	var desired_velocity: Vector2 = agent.global_position.direction_to(_target_point) * speed
	agent.move(desired_velocity)
	agent.update_facing()
	return RUNNING


# Reset state when the task exits.
func _exit() -> void:
	_moving_toward_wall = false


# Dynamically calculate new patrol points around the current position.
func _set_new_patrol_points() -> void:
	var current_pos: Vector2 = agent.global_position
	var left_point = current_pos - Vector2(patrol_range, 0)
	var right_point = current_pos + Vector2(patrol_range, 0)
	
	# Alternate between left and right points
	if _last_direction_right:
		_target_point = right_point
	else:
		_target_point = left_point

	# Update direction flag
	_last_direction_right = !_last_direction_right
	_moving_toward_wall = false


# Reverse patrol direction when hitting a wall.
func _reverse_patrol_direction() -> void:
	var current_pos: Vector2 = agent.global_position
	var new_target = current_pos - Vector2(retreat_range, 0)
	
	# Move the agent away from the wall for a retreat
	_target_point = new_target
	_moving_toward_wall = true
