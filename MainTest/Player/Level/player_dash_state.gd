extends NodeState

signal death

@export_category("Dash State")

@export var character_body_2d: CharacterBody2D
@export var dash_distance: float = 350.0
@export var dash_duration: float = 0.27  # Duration of the dash in seconds
@export var dash_cooldown: float = 6.0  # Time until you can dash again
@onready var dash_timer: Timer = $"../../Dash_Timer"

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var health: Health = $"../../Health"

var _is_dead: bool = false
var _is_dashing: bool = false  # Flag to track if dashing

func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)

func on_process(_delta: float):
	pass
func on_physics_process(_delta: float):
	# If dashing, apply dash logic
	var direction: float = GameInputEvents.movement_input()
	if _is_dashing:
		character_body_2d.velocity = Vector2(dash_distance * direction, 0)
		character_body_2d.move_and_slide()
		return  # Skip further processing while dashing

	# Check for other inputs
	if character_body_2d.is_on_floor():
		transition.emit("Idle")
	else:
		transition.emit("Fall")


	if GameInputEvents.jump_input():
		transition.emit("Jump")
	elif abs(direction) > 0.1:
		transition.emit("Run")

func enter():
# Reset the dash timer when entering the dash state
	dash_timer.stop()
	_is_dashing = true
	animation_player.play("Dash")

		# Use a timer to exit the dash state after the duration
	await get_tree().create_timer(dash_duration).timeout  # Use yield to wait for the timer
	_is_dashing = false
	transition.emit("Idle")

func exit():
	#print("Dashing ended!")  # Debug statement
	_is_dashing = false
	dash_timer.start()
	character_body_2d.velocity.x = 0  # Stop the dash velocity
	animation_player.stop()

func _damaged(_amount: float, knockback: Vector2) -> void:
	apply_knockback(knockback)
	animation_player.play("Hurt")
	await animation_player.animation_finished

func apply_knockback(knockback: Vector2, frames: int = 10) -> void:
	if knockback.is_zero_approx():
		return
	for i in range(frames):
		move(knockback)
		await get_tree().physics_frame

func move(p_velocity: Vector2) -> void:
	character_body_2d.velocity = lerp(character_body_2d.velocity, p_velocity, 0.2)
	character_body_2d.move_and_slide()

func get_health() -> Health:
	return health

func die() -> void:
	if _is_dead:
		return
	death.emit()
	_is_dead = true


func _on_dash_timer_timeout() -> void:
	pass # Replace with function body.
