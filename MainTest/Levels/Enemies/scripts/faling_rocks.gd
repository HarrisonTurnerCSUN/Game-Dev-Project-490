extends RigidBody2D

signal death

@onready var sprite_2d: Sprite2D = $Sprite2D
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health: Health = $Health
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var _is_dead: bool = false

func _ready() -> void:
	health.damaged.connect(_on_damaged)
	health.death.connect(die)
	
	#audio_stream_player_2d.play()
	# Set up a timer to auto-delete after 3 seconds
	var timer = Timer.new()
	timer.wait_time = 4.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(queue_free)

func _on_damaged(amount: float, knockback: Vector2) -> void:
	if _is_dead:
		return

	# Apply knockback
	apply_knockback(knockback)

	# Play the hurt animation
	#animation_player.play("Hurt")

func apply_knockback(knockback: Vector2) -> void:
	# Add knockback to the rigid body's velocity
	linear_velocity += knockback
	#print("Knockback applied: ", knockback, ", New velocity: ", linear_velocity)

func die() -> void:
	if _is_dead:
		return

	_is_dead = true
	death.emit()
	
	 # Freeze the rigid body and reset its rotation
	#mode = RigidBody2D.MODE_STATIC
	rotation = 0  # Reset the box's rotation to upright
	collision_mask = 1 
	# Play the death animation
	#animation_player.play("Death")

	# Wait for the death animation to finish, then disable collision and remove the object
	#await animation_player.animation_finished
	collision_shape_2d.set_deferred("disabled", true)
	#audio_stream_player_2d.stop()
	queue_free()
