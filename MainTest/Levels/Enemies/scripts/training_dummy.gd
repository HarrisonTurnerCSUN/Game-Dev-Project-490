extends CharacterBody2D

signal death

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health: Health = $Health
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var training_dummy: CharacterBody2D = $"."

var _is_dead: bool = false

func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)

func on_physics_process(_delta :float):
	pass
	
func _physics_process(_delta: float) -> void:
	velocity.y = 0
	if !training_dummy.is_on_floor():
		training_dummy.velocity.y += 1000
	training_dummy.move_and_slide()
	if _is_dead:
		velocity.y += 20  # Adjust this gravity value as needed
		move_and_collide(velocity * _delta)
	#if is_on_wall() and &"InRange":
		#velocity.y = jump_power
	_post_physics_process.call_deferred()
	


func _post_physics_process() -> void:
	pass

func move(p_velocity: Vector2) -> void:
	pass

func is_good_position(p_position: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = p_position
	params.collision_mask = 1 # Obstacle layer has value 1
	var collision := space_state.intersect_point(params)
	return collision.is_empty()
	
func _damaged(_amount: float, knockback: Vector2) -> void:
	apply_knockback(knockback)
	animation_player.play("Hurt")
	await animation_player.animation_finished
	animation_player.play("Idle")

func apply_knockback(_knockback: Vector2, _frames: int = 10) -> void:
	pass
	#pass


func die() -> void:
	if _is_dead:
		return
	death.emit()
	_is_dead = true
	sprite_2d.process_mode = Node.PROCESS_MODE_DISABLED
	#animation_player.play("Death")
	#collision_shape_2d.set_deferred("disabled", true)
	self.collision_layer = 0
	self.collision_mask = 1
	if get_tree():
		await get_tree().create_timer(3.0).timeout
		queue_free()


func get_health() -> Health:
	return health
