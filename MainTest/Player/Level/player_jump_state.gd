extends NodeState

signal death

@export var character_body_2d : CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"
@onready var health: Health = $"../../Health"

@export_category("Jump state")
@export var jump : float = -350
@export var jump_speed : int = 200
@export var max_jump_speed : int = 200
@export var gravity : int = 800

var _is_dead: bool = false
var _moved_this_frame: bool = false
var _has_jumped: bool = false  # Flag to track if the jump has been initiated

func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)

func on_process(_delta: float):
	pass
	
func on_physics_process(_delta: float):
	var direction : float = GameInputEvents.movement_input()
	
	# Check for jump input and ground state
	if character_body_2d.is_on_floor():
		character_body_2d.velocity.y = jump  # Apply jump velocity
		_has_jumped = true  # Set flag to true after jumping
	
		# Apply gravity to the vertical velocity
	character_body_2d.velocity.y += gravity * _delta
	
	if direction != 0:
		sprite_2d.flip_h = false if direction > 0 else true 
	
	if !character_body_2d.is_on_floor():
		# Apply horizontal movement while in the air
		character_body_2d.velocity.x += direction * jump_speed
		character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_jump_speed, max_jump_speed)
	else:
		# Dampen horizontal velocity when on the floor
		character_body_2d.velocity.x = lerp(character_body_2d.velocity.x, 0.0, 0.3)  # Adjust as needed

	# Move the character
	character_body_2d.move_and_slide()
	
	# Transition states
	if character_body_2d.is_on_floor():
		transition.emit("Idle")
		_has_jumped = false  # Reset jump flag when on the ground
		
	if !character_body_2d.is_on_floor() and character_body_2d.velocity.y > 0:
		transition.emit("Fall")
		
	if GameInputEvents.shift_input():
		transition.emit("AirDash")
	
	if GameInputEvents.jump_input() and _has_jumped:
		transition.emit("DoubleJump")
		
func _post_physics_process() -> void:
	if not _moved_this_frame:
		character_body_2d.velocity.x = lerp(character_body_2d.velocity.x, 0.0, 0.2)  # Adjust as needed
	_moved_this_frame = false
	
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
	_moved_this_frame = true
	
func get_health() -> Health:
	return health

func die() -> void:
	if _is_dead:
		return
	death.emit()
	_is_dead = true

func enter():
	animation_player.play("Jump")
	
func exit():
	pass
