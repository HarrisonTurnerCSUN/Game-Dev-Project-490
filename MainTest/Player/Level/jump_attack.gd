extends NodeState

@onready var timer: Timer = $"../../Timer"
@export var character_body_2d: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"
@export var friction: int = 500
@onready var stamina: Stamina = $"../../Stamina"

@export_category("JumpAttack state")
@export var fall_speed: int = 700  # Speed of falling
@export var air_horizontal_speed: int = 200  # Horizontal speed in the air
@export var max_air_horizontal_speed: int = 200

var is_attacking: bool = false

func on_process(_delta: float):
	pass

func on_physics_process(_delta: float):
	var direction: float = GameInputEvents.movement_input()

	# Apply fall speed to the vertical velocity
	character_body_2d.velocity.y += fall_speed * _delta

	# Allow horizontal movement in the air
	if direction != 0:
		sprite_2d.flip_h = direction < 0
		var target_velocity_x = direction * air_horizontal_speed
		character_body_2d.velocity.x = lerp(character_body_2d.velocity.x, target_velocity_x, 0.1)  # Smooth transition

	# Clamp horizontal velocity to max limit
	character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_air_horizontal_speed, max_air_horizontal_speed)

	# Move the character
	character_body_2d.move_and_slide()

	# Check for transitions
	if character_body_2d.is_on_floor():
		transition.emit("Idle")

	if GameInputEvents.shift_input() and !is_attacking:
		if stamina.use_stamina(2):
			is_attacking = true
			transition.emit("Dash")
		else:
			print("Not enough stamina!")

func enter():
	# Initialize the state
	is_attacking = false
	animation_player.play("JumpAttack")

func exit():
	# Reset any state-specific variables if needed
	is_attacking = false
