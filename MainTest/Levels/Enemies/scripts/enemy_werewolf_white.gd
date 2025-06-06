extends CharacterBody2D

signal death
signal damaged_by_player

var _frames_since_facing_update: int = 0
var _is_dead: bool = false
var _moved_this_frame: bool = false
var _can_be_hit: bool = true  # New variable to track hit cooldown
var has_healed_at_30: bool = false
var has_healed_at_15: bool = false
var _is_healing: bool = false
var _healing_amount: int = 1
@export var heal_area_1: Area2D
@export var heal_area_2: Area2D
@export var heal_area_3: Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health: Health = $Health
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Hurtbox = $Sprite2D/Hurtbox
@onready var hitbox: Hitbox = $Sprite2D/Hitbox
@onready var stun_bar: ProgressBar = $stunBar
@onready var health_bar: ProgressBar = $HealthBar
const EnemyScene1 := preload("res://Levels/Enemies/Werewolf_black/enemy_werewolf_black.tscn")
const EnemyScene2 := preload("res://Levels/Enemies/Werewolf_black/enemy_werewolf_redd.tscn")

#const jump_power = -300
const gravity = 50
const speed = 100


func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)
	stun_bar.stunned.connect(_on_stunned)
	self.collision_layer = 3
	self.collision_layer = 1 | 2

func _physics_process(_delta: float) -> void:
	#if is_on_wall() and &"InRange":
		#velocity.y = jump_power
		#velocity.x = get_facing() * 10
	#else:
	velocity.y += gravity
	move_and_slide()
	_post_physics_process.call_deferred()

func _post_physics_process() -> void:
	if not _moved_this_frame:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
	_moved_this_frame = false
	
func move(p_velocity: Vector2) -> void:
	velocity = lerp(velocity, p_velocity, 0.2)
	move_and_slide()
	_moved_this_frame = true

@warning_ignore("shadowed_variable")
func walk(dir: float, speed: float) -> void:
	velocity.x = dir * speed

## Update agent's facing in the velocity direction.
func update_facing() -> void:
	_frames_since_facing_update += 1
	if _frames_since_facing_update > 3:
		face_dir(velocity.x)

## Face specified direction.
func face_dir(dir: float) -> void:
	if dir > 0.0 and sprite_2d.scale.x < 0.0:
		sprite_2d.scale.x = 1.0
		_frames_since_facing_update = 0
	if dir < 0.0 and sprite_2d.scale.x > 0.0:
		sprite_2d.scale.x = -1.0
		_frames_since_facing_update = 0

## Returns 1.0 when agent is facing right.
## Returns -1.0 when agent is facing left.
func get_facing() -> float:
	return sign(sprite_2d.scale.x)

## Is specified position inside the arena (not inside an obstacle)?
func is_good_position(p_position: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = p_position
	params.collision_mask = 1 # Obstacle layer has value 1
	var collision = space_state.intersect_point(params)
	return collision.is_empty()

## When agent is damaged...
func _damaged(_amount: float, knockback: Vector2) -> void:
	if not _can_be_hit or _is_dead:
		return

	# Interrupt healing if we're in that state
	if _is_healing:
		_end_healing()
		return

	# Begin healing if conditions met
	if get_health().get_current() <= 15 and not has_healed_at_15:
		has_healed_at_15 = true
		await _teleport_and_heal()
		_healing_amount = 2
		return
	elif get_health().get_current() <= 30 and not has_healed_at_30:
		has_healed_at_30 = true
		await _teleport_and_heal()
		return
		
	_can_be_hit = false
	emit_signal("damaged_by_player")
	apply_knockback(knockback)
	await get_tree().create_timer(0.3).timeout
	_can_be_hit = true
	
func _on_stunned() -> void:
	animation_player.play("Hurt")
	var btplayer = get_node_or_null("BTPlayer") as BTPlayer
	var hsm = get_node_or_null("LimboHSM")
	if btplayer:
		btplayer.set_active(false)
	if hsm:
		hsm.set_active(false)
	
	await get_tree().create_timer(2).timeout
	
	if btplayer and not _is_dead:
		btplayer.restart()
	if hsm and not _is_dead:
		hsm.set_active(true)

## Push agent in the knockback direction for the specified number of physics frames.
func apply_knockback(knockback: Vector2, frames: int = 10) -> void:
	if knockback.is_zero_approx():
		return
	for i in range(frames):
		move(knockback)
		await get_tree().physics_frame


func die() -> void:
	if _is_dead:
		return
	death.emit()
	_is_dead = true
	sprite_2d.process_mode = Node.PROCESS_MODE_DISABLED
	animation_player.play("Death")
	self.collision_layer = 0
	self.collision_mask = 1

	# Disable relevant children and prepare for destruction
	for child in get_children():
		if child is BTPlayer or child is LimboHSM:
			child.set_active(false)

	# Schedule spawning a new enemy after death animation
	RewardController.show_reward_screen()
	# Remove the current instance after 10 seconds
	if get_tree():
		await get_tree().create_timer(5.0).timeout
		queue_free()
		
func show_hurt_ui():
	pass
	
func get_health() -> Health:
	return health
	
func _teleport_and_heal() -> void:
	_can_be_hit = false
	var btplayer = get_node_or_null("BTPlayer")
	var hsm = get_node_or_null("LimboHSM")
	if btplayer: btplayer.set_active(false)
	if hsm: hsm.set_active(false)
	animation_player.play("PoofAway")
	var area_data := _get_random_heal_area()
	var chosen_area: Area2D = area_data["chosen"]
	var other_areas: Array = area_data["others"]
	if not is_instance_valid(chosen_area):
		push_warning("No valid heal area assigned!")
		return



	var target_pos = chosen_area.global_position
	
	# Slow fade out
	for i in range(20):
		sprite_2d.modulate.a = 1.0 - (i / 20.0)
		await get_tree().create_timer(0.1).timeout

	global_position = target_pos
	animation_player.play("HealUP")
	
		# Spawn enemies at the unused areas
	if EnemyScene1 and is_instance_valid(other_areas[0]):
		var enemy1 = EnemyScene1.instantiate()
		enemy1.global_position = other_areas[0].global_position
		get_parent().call_deferred("add_child", enemy1)

	if EnemyScene2 and is_instance_valid(other_areas[1]):
		var enemy2 = EnemyScene2.instantiate()
		enemy2.global_position = other_areas[1].global_position
		get_parent().call_deferred("add_child", enemy2)
		
	# Begin healing loop
	_is_healing = true
	_can_be_hit = true
	while _is_healing:
		await get_tree().create_timer(2.0).timeout
		if not _is_healing:
			break  # Interrupted during wait

		health._current = min(health._current + _healing_amount, health.max_health)
		health_bar.update_health_display()
		#print("Healing... HP:", health._current)

		if health._current >= health.max_health:
			_end_healing()
			break

func _end_healing() -> void:
	#print("Healing ended.")
	_is_healing = false

	# Fade back in
	for i in range(20):
		sprite_2d.modulate.a = i / 20.0
		await get_tree().create_timer(0.05).timeout

	var btplayer = get_node_or_null("BTPlayer")
	var hsm = get_node_or_null("LimboHSM")
	if btplayer and not _is_dead:
		btplayer.restart()
	if hsm and not _is_dead:
		hsm.set_active(true)

func _get_random_heal_area() -> Dictionary:
	var all_areas = [heal_area_1, heal_area_2, heal_area_3]
	all_areas.shuffle()

	return {
		"chosen": all_areas[0],
		"others": [all_areas[1], all_areas[2]]
	}
