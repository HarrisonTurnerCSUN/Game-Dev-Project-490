extends Node2D
## projectile

const SPEED := 150.0  # Increase the horizontal speed for more distance
const DEAD_SPEED := 50.0
const HIGH_ARC_HEIGHT := 90.0  # Maximum height of the arc
const ARC_DURATION := 1.1  # Total duration for the arc (up + down)

@export var dir: float = 1.0  # Direction of the projectile

var _is_dead: bool = false
var _elapsed_time: float = 0.0
@onready var projectile: Sprite2D = $Root/projectile
@onready var root: Node2D = $Root
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Set initial position for the arc
	position.y = global_position.y
	_elapsed_time = 0.0

func _physics_process(delta: float) -> void:
	if not _is_dead:
		_elapsed_time += delta
		
		# Update horizontal position with increased speed
		position.x += SPEED * dir * delta
		
		# Calculate the vertical position using a sine wave for smoother arc
		var t = _elapsed_time / ARC_DURATION  # Normalize time
		if t <= 1.0:
			position.y = -HIGH_ARC_HEIGHT * sin(t * PI)  # Arc up to the peak
		else:
			_die()  # End of arc, trigger death

func _die() -> void:
	if _is_dead:
		return
	_is_dead = true
	animation_player.play("Death")
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	create_timer_to_free()

func create_timer_to_free() -> void:
	var timer = Timer.new()
	timer.wait_time = 0.5  # Time to wait after death animation before despawning
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

func _on_timer_timeout() -> void:
	root.hide()
	queue_free()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	_die()
