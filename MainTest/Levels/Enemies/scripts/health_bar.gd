extends ProgressBar

@export var health_node: Health  # Assign the Health node in the editor
@onready var timer: Timer = $Damagebar/Timer
@onready var damage_bar: ProgressBar = $Damagebar

func _ready() -> void:
	# Ensure the health_node is properly assigned
	if health_node:
		health_node.connect("damaged", Callable(self, "_on_health_damaged"))
		health_node.connect("death", Callable(self, "_on_health_death"))
		init_health_bar(health_node.max_health)
	else:
		print("Error: Health node is not assigned.")

func init_health_bar(max_health_value: float):
	# Initialize the health and damage bars
	max_value = max_health_value
	value = health_node.get_current()
	damage_bar.max_value = max_health_value
	damage_bar.value = health_node.get_current()

func _on_health_damaged(_amount: float, _knockback: Vector2) -> void:
	# Update the health bar instantly
	value = health_node.get_current()
	# Start the timer for delayed update of the damage bar
	timer.start()

func _on_health_death() -> void:
	# Update the health bar to zero on death
	#value = 0
	#damage_bar.value = 0
	queue_free()

func update_health_display() -> void:
	value = health_node.get_current()
	damage_bar.value = health_node.get_current()
	
func _on_timer_timeout() -> void:
	damage_bar.value = health_node.get_current()
