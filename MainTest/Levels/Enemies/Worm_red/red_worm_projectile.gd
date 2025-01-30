extends RigidBody2D

const SPEED := 180  # Horizontal speed (distance per second)
const ARC_HEIGHT := 95.0  # Adjust the height of the arc (lower value for a smoother arc)
const ARC_DURATION := 1.5  # Duration of the arc (slower descent and ascent)
const GRAVITY := 500.0  # Gravity pulling the projectile downward

@export var dir: float = 1.0  # Direction (1 for right, -1 for left)

var _is_dead: bool = false
var _elapsed_time: float = 0.0
var velocity: Vector2 = Vector2.ZERO  # Velocity to store movement

@onready var timer: Timer = $Timer
@onready var root: Node2D = $Root
@onready var projectile: Sprite2D = $Root/projectile
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	timer.start()
	# Set the initial spawn position relative to the goblin
	#var character_position = get_parent().global_position
	#global_position = character_position + Vector2(15 * dir, -7)  # Adjust spawn position offset

	# Calculate initial velocity for the projectile based on desired arc
	velocity.x = SPEED * dir  # Set the horizontal velocity based on direction

	# Adjust the vertical velocity to achieve the desired height
	velocity.y = -sqrt(2 * GRAVITY * ARC_HEIGHT) * 0.7  # Reduced vertical velocity (scaled down)

	#print("Bomb spawned at position: ", global_position)
	#print("Initial velocity: ", velocity)

func _physics_process(delta: float) -> void:
	if not _is_dead:
		_elapsed_time += delta
		
		# Apply gravity to vertical velocity
		velocity.y += GRAVITY * delta  # Gravity pulls downward

		# Apply velocity to position (horizontal and vertical movement)
		position += velocity * delta
		
		# Log the position when it reaches the peak (near the midpoint of the arc)
		#if velocity.y > 0 and position.y > global_position.y:
			#print("Bomb reached top of arc at position: ", position)

func _die() -> void:
	if _is_dead:
		return
	_is_dead = true
	#print("Bomb arc completed at position: ", position)  # Log final position
	animation_player.play("Death")
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Death":
		root.hide()
		queue_free()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	_die()


	
func _on_timer_timeout() -> void:
	_die()
