extends CharacterBody2D

signal death
signal rock_drop

const Projectile := preload("res://Levels/Enemies/Goblin/goblin_projectile.tscn")
const RockScene := preload("res://Levels/Enemies/Stone Golem/RumblingRock.tscn")
const FallingRocks := preload("res://Levels/Enemies/Stone Golem/falingRocks.tscn")
@onready var top_leftm: Marker2D = $TopLeft
@onready var bottom_rightm: Marker2D = $BottomRight
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var _frames_since_facing_update: int = 0
var _is_dead: bool = false
var _moved_this_frame: bool = false
var target_position: Vector2  # Position the Golem will move toward

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health: Health = $Health
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Hurtbox = $Sprite2D/Hurtbox
@onready var hitbox: Hitbox = $Sprite2D/Hitbox

const speed = 80  # Adjust speed as needed
const hover_strength = 50  # Strength of vertical floating movement
const hover_frequency = 2.0  # Speed of the hover oscillation

func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)
	self.collision_layer = 3
	self.collision_layer = 1 | 2

func _physics_process(delta: float) -> void:
	if _is_dead:
		velocity.y += 20  # Keep falling when dead
		move_and_collide(velocity * delta)
		return
	
	# Hovering effect (oscillates up and down)
	velocity.y = sin(Time.get_ticks_msec() / 1000.0 * hover_frequency) * hover_strength
	
	# Adjust gravity based on facing direction
	if get_facing() > 0:  # If facing right, go down
		velocity.y += 100  # Increase gravity to make it move downward faster
	else:  # If facing left, use default gravity
		velocity.y += 0

	# Move toward target if assigned
	if target_position:
		move_toward_target(delta)

	move_and_slide()
	_post_physics_process.call_deferred()

func move_toward_target(delta: float) -> void:
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed

func _post_physics_process() -> void:
	if not _moved_this_frame:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
	_moved_this_frame = false

func move(p_velocity: Vector2) -> void:
	velocity = lerp(velocity, p_velocity, 0.2)
	move_and_slide()
	_moved_this_frame = true

func set_target(pos: Vector2) -> void:
	target_position = pos

func update_facing() -> void:
	_frames_since_facing_update += 1
	if _frames_since_facing_update > 3:
		face_dir(velocity.x)

func face_dir(dir: float) -> void:
	var btplayer = get_node_or_null("BTPlayer") as BTPlayer
	if dir > 0.0 and sprite_2d.scale.x < 0.0:
		sprite_2d.scale.x = 1.0
		if btplayer:
			btplayer.blackboard.set_var("facing", 1)
		_frames_since_facing_update = 0
	if dir < 0.0 and sprite_2d.scale.x > 0.0:
		sprite_2d.scale.x = -1.0
		if btplayer:
			btplayer.blackboard.set_var("facing", -1)
		_frames_since_facing_update = 0

func get_facing() -> float:
	return sign(sprite_2d.scale.x)

func _damaged(_amount: float, knockback: Vector2) -> void:
	if _is_dead:
		return  
	else: 
		increase_scale_smoothly()
		call_deferred("spawn_rumbling_rocks")

func die() -> void:
	if _is_dead:
		return
	death.emit()
	_is_dead = true
	sprite_2d.process_mode = Node.PROCESS_MODE_DISABLED
	animation_player.play("Death")
	self.collision_layer = 0
	self.collision_mask = 1
	for child in get_children():
		if child is BTPlayer or child is LimboHSM:
			child.set_active(false)
	
	RewardController.show_reward_screen()
	if get_tree():
		await get_tree().create_timer(10.0).timeout
		queue_free()

func throw_projectile() -> void:
	var projectile = Projectile.instantiate()
	projectile.dir = get_facing()
	get_parent().add_child(projectile)
	var offset_x = 20 * get_facing()
	var offset_y = 60
	projectile.global_position = global_position + Vector2(offset_x, offset_y)

func increase_scale_smoothly():
	var tween = create_tween()
	var target_scale = scale * 1.1
	target_scale.x = min(target_scale.x, 2)
	target_scale.y = min(target_scale.y, 2)
	tween.tween_property(self, "scale", target_scale, 0.5)

func spawn_rumbling_rocks():
	var count := randi_range(6, 10)
	for i in range(count):
		await get_tree().create_timer(0.2).timeout  # Spawns 1 rock every 0.1s

		var rock = RockScene.instantiate()
		get_parent().add_child(rock)

		# Random horizontal offset around the golem
		var offset_x = randi_range(-200, 200)
		var spawn_pos = global_position + Vector2(offset_x, 0)

		# Snap to the ground (basic approximation)
		spawn_pos.y = get_ground_y_below(spawn_pos)

		rock.global_position = spawn_pos
		rock.scale.x = -1 if randi() % 2 == 0 else 1
		rock.play_animation_first()
		
func spawn_rocks_in_area():
	var top_left = top_leftm.global_position
	var bottom_right = bottom_rightm.global_position

	var min_x = min(top_left.x, bottom_right.x)
	var max_x = max(top_left.x, bottom_right.x)
	var min_y = min(top_left.y, bottom_right.y)
	var max_y = max(top_left.y, bottom_right.y)

	var rock_count = randi_range(6, 10)
	
	audio_stream_player_2d.play()
	for i in range(rock_count):
		await get_tree().create_timer(0.2).timeout
		var rock = FallingRocks.instantiate()
		var random_x = randf_range(min_x, max_x)
		var random_y = randf_range(min_y, max_y)
		rock.global_position = Vector2(random_x, random_y)
		get_tree().current_scene.add_child(rock)
		rock.scale.x = 1 if randf() > 0.5 else -1
	audio_stream_player_2d.stop()

func get_ground_y_below(start_pos: Vector2, max_distance: float = 300.0) -> float:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_pos, start_pos + Vector2.DOWN * max_distance)
	query.collide_with_areas = false
	query.collide_with_bodies = true

	var result = space_state.intersect_ray(query)
	if result:
		return result.position.y
	else:
		return start_pos.y  # No ground found, fallback to original Y
