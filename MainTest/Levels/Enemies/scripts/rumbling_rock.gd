extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	# Set high gravity so the rock falls fast if in air
	if not is_on_ground():
		velocity.y = 1500  # Apply a strong downward velocity

func _physics_process(delta: float) -> void:
	if not is_on_ground():
		velocity.y += 50 * delta  # Apply gravity effect
	move_and_slide()

func ensure_on_ground():
	await get_tree().physics_frame  # Wait 1 frame to update position
	while not is_on_ground():
		await get_tree().physics_frame  # Keep checking until it lands

func is_on_ground() -> bool:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, 10))
	params.collide_with_areas = false
	params.collide_with_bodies = true
	var result = space_state.intersect_ray(params)
	return result.size() > 0  # Returns true if it detects ground

func play_animation_first():
	animation_player.play("Idle")

func spike():
	animation_player.play("Spike")
	
func fist():
	animation_player.play("Fist")

func die():
	queue_free()
