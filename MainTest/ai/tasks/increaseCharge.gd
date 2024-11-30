extends BTAction

@export var charge_speed_var: StringName = "charge_speed"  # Blackboard variable for charge speed
@export var speed_var: StringName = "speed"  # Blackboard variable for speed

func _tick(delta: float) -> Status:
	# Update charge_speed
	var charge_speed: float = blackboard.get_var(charge_speed_var, 0.0)
	charge_speed = min(charge_speed + 25, 250)
	blackboard.set_var(charge_speed_var, charge_speed)
	
	# Update speed
	var speed: float = blackboard.get_var(speed_var, 0.0)
	speed = min(speed + 10, 180)
	blackboard.set_var(speed_var, speed)
	
	# Task completed successfully
	return Status.SUCCESS
