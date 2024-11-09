extends NodeState

signal death

@export_category("Fall state")
@export var character_body_2d : CharacterBody2D
@export var fall_speed : int = 700  # Speed of falling
@export var air_horizontal_speed: int = 200  # Horizontal speed in the air
@export var max_air_horizontal_speed: int = 200

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"
@onready var health: Health = $"../../Health"



var can_dash: bool = true
var _is_dead: bool = false

func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)

func on_process(_delta: float):
	pass

func on_physics_process(_delta: float):

	var direction: float = GameInputEvents.movement_input()

	# Apply fall speed to the vertical velocity
	character_body_2d.velocity.y += fall_speed * _delta

	# Allow horizontal movement in the air
	if direction != 0:
		sprite_2d.flip_h = false if direction > 0 else true 
		var target_velocity_x = direction * air_horizontal_speed
		character_body_2d.velocity.x = lerp(character_body_2d.velocity.x, target_velocity_x, 0.1)  # Smooth transition

	# Clamp horizontal velocity to max limit
	character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_air_horizontal_speed, max_air_horizontal_speed)

	# Move the character
	character_body_2d.move_and_slide()

	# Transition states
	if character_body_2d.is_on_floor():
		transition.emit("Idle")  # Transition to Idle when grounded
		
	if character_body_2d.is_on_wall_only() and direction != 0:
		transition.emit("WallSlide")
		
# In Jump and Fall states
	if GameInputEvents.shift_input() and can_dash:
		can_dash = false
		print(can_dash)
		transition.emit("Dash")

func _damaged(_amount: float, knockback: Vector2) -> void:
	# Handle damage and knockback
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

func enter():
	animation_player.play("Fall")  # Play fall animation
	#print("Fall")

func exit():
	animation_player.stop()


func _on_dash_timer_timeout() -> void:
	can_dash = true
	print(can_dash)
