extends ProgressBar

@export var max_hits: int = 5
@export var drain_speed: float = 20.0  # Percent per second (ex: 20 = drain in 5 sec)
@export var health_node: Health
@export var character_node: CharacterBody2D
@onready var stun_drain_bar: ProgressBar = $stunDrainBar

var current_hits: int = 0
var is_stunned: bool = false

signal stunned

func _ready() -> void:
	health_node.connect("death", _on_health_death)
	character_node.connect("damaged_by_player", add_hit)

	max_value = max_hits
	value = 0

	stun_drain_bar.max_value = 100
	stun_drain_bar.value = 0

func add_hit():
	if is_stunned:
		return

	current_hits += 1
	value = current_hits

	if current_hits >= max_hits:
		is_stunned = true
		value = 0  # Reset hit bar
		current_hits = 0
		stun_drain_bar.value = 100  # Full visual for stun
		emit_signal("stunned")

func _process(delta: float) -> void:
	if is_stunned:
		stun_drain_bar.value = max(stun_drain_bar.value - drain_speed * delta, 0)

		if stun_drain_bar.value <= 0:
			is_stunned = false

func _on_health_death() -> void:
	queue_free()
