extends NodeState

signal death

@export_category("Jump state")

@export var fall_horizontal_speed : int = 200
@export var max_fall_horizontal_speed : int = 200
@export var character_body_2d : CharacterBody2D
@export var gravity : int = 700

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"
@onready var hitbox: Hitbox = $"../../Sprite2D/Hitbox"
@onready var health: Health = $"../../Health"



var _is_dead: bool = false
var _moved_this_frame: bool = false

func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)

func on_process(_delta :float):
	pass
	
func on_physics_process(_delta :float):
	var direction : float = GameInputEvents.movement_input()
	# Apply gravity to simulate falling
	if not character_body_2d.is_on_floor():
		character_body_2d.velocity.y += gravity * _delta  # Fall only when airborne

	if direction != 0:
		sprite_2d.flip_h = false if direction > 0 else true
		hitbox.scale.x = -1 if sprite_2d.flip_h else 1  # Update hitbox scale based on sprite flip
	
	if !character_body_2d.is_on_floor():
		character_body_2d.velocity.x += direction * fall_horizontal_speed * _delta
		character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_fall_horizontal_speed, max_fall_horizontal_speed)
	else:
		# Decelerate faster when grounded
		character_body_2d.velocity.x = lerp(character_body_2d.velocity.x, 0.0, 0.4)

	character_body_2d.move_and_slide()
	
	#Transition
	if character_body_2d.is_on_floor() and character_body_2d.velocity.y >= 0:
		transition.emit("Idle")
		
	if GameInputEvents.shift_input():
		transition.emit("AirDash")
	
	if GameInputEvents.jump_input() and character_body_2d.velocity.y > -100:
		#print("double")
		transition.emit("DoubleJump")

func _post_physics_process() -> void:
	if character_body_2d.is_on_floor():
		character_body_2d.velocity.x = lerp(character_body_2d.velocity.x, 0.0, 0.2)  # Adjust as needed
	_moved_this_frame = false
	
func move(p_velocity: Vector2) -> void:
	character_body_2d.velocity = lerp(character_body_2d.velocity, p_velocity, 0.2)
	character_body_2d.move_and_slide()
	_moved_this_frame = true
	
func _damaged(_amount: float, knockback: Vector2) -> void:
	#print("Current Health: ", health.get_current())  # Print the current health
	apply_knockback(knockback)
	animation_player.play("Hurt")
	await animation_player.animation_finished


func apply_knockback(knockback: Vector2, frames: int = 10) -> void:
	if knockback.is_zero_approx():
		return
	for i in range(frames):
		move(knockback)
		await get_tree().physics_frame

func get_health() -> Health:
	return health

	
func die() -> void:
	if _is_dead:
		return
	death.emit()
	_is_dead = true
	pass
	
func enter():
	animation_player.play("Fall")
	character_body_2d.velocity.y += gravity * 0.1  # Small boost to start the fall
func exit():
	pass
	#animation_player.stop()
	
