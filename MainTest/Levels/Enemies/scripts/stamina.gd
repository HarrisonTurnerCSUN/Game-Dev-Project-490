class_name Stamina
extends Node
## Tracks stamina and handles regeneration and depletion.

## Emitted when stamina is fully depleted.
signal stamina_depleted

## Emitted when stamina is used.
signal stamina_used(amount: float)

## Maximum stamina value.
@export var max_stamina: float = 100.0

## Stamina regeneration rate (per second).
@export var stamina_per_second: float = 5.0

var _current_stamina: float

func _ready() -> void:
	_current_stamina = max_stamina

	# Set up a process to regenerate stamina every frame.
	set_process(true)

func _process(delta: float) -> void:
	# Regenerate stamina over time.
	_current_stamina += stamina_per_second * delta
	_current_stamina = min(_current_stamina, max_stamina)

func use_stamina(amount: float) -> bool:
	## Reduces current stamina by the specified amount.
	## Returns true if the stamina was successfully reduced, false if insufficient.
	if _current_stamina >= amount:
		_current_stamina -= amount
		stamina_used.emit(amount)
		if _current_stamina <= 0.0:
			stamina_depleted.emit()
		return true
	else:
		# Not enough stamina
		return false

## Returns current stamina.
func get_current_stamina() -> float:
	return _current_stamina

## Set stamina to a specific value (clamped between 0 and max_stamina).
func set_current_stamina(value: float) -> void:
	_current_stamina = clamp(value, 0.0, max_stamina)
