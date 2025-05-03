extends CharacterBody2D

signal death

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health: Health = $Health
@onready var left_top_box: CollisionShape2D = $LeftTopBox
@onready var left_bottom_box: CollisionShape2D = $LeftBottomBox
@onready var left_middle_box: CollisionShape2D = $LeftMiddleBox
@onready var right_top_box: CollisionShape2D = $RightTopBox
@onready var right_middle_box: CollisionShape2D = $RightMiddleBox
@onready var right_bottom_box: CollisionShape2D = $RightBottomBox

const MINION_RESOURCE := "res://Levels/Enemies/Undead_Excutioner/enemy_undead_summon.tscn"
const jump_power = -400

var _frames_since_facing_update: int = 0
var _is_dead: bool = false
var _moved_this_frame: bool = false
var _summoned_at_75: bool = false
var _summoned_at_50: bool = false
var _summoned_at_25: bool = false

		
func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)


func _physics_process(_delta: float) -> void:
	if _is_dead:
		velocity.y += 20  # Adjust this gravity value as needed
		move_and_collide(velocity * _delta)
	#if is_on_wall() and &"InRange":
		#velocity.y = jump_power
	_post_physics_process.call_deferred()
	


func _post_physics_process() -> void:
	if not _moved_this_frame:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
	_moved_this_frame = false


func move(p_velocity: Vector2) -> void:
	velocity = lerp(velocity, p_velocity, 0.2)
	move_and_slide()
	_moved_this_frame = true


## Update agent's facing in the velocity direction.
func update_facing() -> void:
	_frames_since_facing_update += 1
	if _frames_since_facing_update > 3:
		face_dir(velocity.x)

## Face specified direction.
func face_dir(dir: float) -> void:
	if dir > 0.0 and sprite_2d.scale.x < 0.0:
		left_top_box.disabled = false
		left_bottom_box.disabled = false
		left_middle_box.disabled = false
		right_top_box.disabled = true
		right_middle_box.disabled = true
		right_bottom_box.disabled = true
		sprite_2d.scale.x = 1.0;
		_frames_since_facing_update = 0
	if dir < 0.0 and sprite_2d.scale.x > 0.0:
		left_top_box.disabled = true
		left_bottom_box.disabled = true
		left_middle_box.disabled = true
		right_top_box.disabled = false
		right_middle_box.disabled = false
		right_bottom_box.disabled = false
		sprite_2d.scale.x = -1.0;
		_frames_since_facing_update = 0

## Returns 1.0 when agent is facing right.
## Returns -1.0 when agent is facing left.
func get_facing() -> float:
	return signf(sprite_2d.scale.x)
	
## Is specified position inside the arena (not inside an obstacle)?
func is_good_position(p_position: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = p_position
	params.collision_mask = 1 # Obstacle layer has value 1
	var collision := space_state.intersect_point(params)
	return collision.is_empty()


## When agent is damaged...
func _damaged(_amount: float, knockback: Vector2) -> void:
	apply_knockback(knockback)
	if not _is_dead and health.get_current() <= health.max_health * 0.75 and not _summoned_at_75:
		_summoned_at_75 = true
		play_death_animation_and_summon75()
		var btplayer := get_node_or_null(^"BTPlayer") as BTPlayer
		if btplayer:
			btplayer.set_active(false)
		var hsm := get_node_or_null(^"LimboHSM")
		if hsm:
			hsm.set_active(false)
		await animation_player.animation_finished
		if btplayer and not _is_dead:
			btplayer.restart()
		if hsm and not _is_dead:
			hsm.set_active(true)
	elif not _is_dead and health.get_current() <= health.max_health * 0.50 and not _summoned_at_50:
		_summoned_at_50 = true
		play_death_animation_and_summon50()
		var btplayer := get_node_or_null(^"BTPlayer") as BTPlayer
		if btplayer:
			btplayer.set_active(false)
		var hsm := get_node_or_null(^"LimboHSM")
		if hsm:
			hsm.set_active(false)
		await animation_player.animation_finished
		if btplayer and not _is_dead:
			btplayer.restart()
		if hsm and not _is_dead:
			hsm.set_active(true)
	elif not _is_dead and health.get_current() <= health.max_health * 0.25 and not _summoned_at_25:
		_summoned_at_25 = true
		play_death_animation_and_summon25()
		var btplayer := get_node_or_null(^"BTPlayer") as BTPlayer
		if btplayer:
			btplayer.set_active(false)
		var hsm := get_node_or_null(^"LimboHSM")
		if hsm:
			hsm.set_active(false)
		await animation_player.animation_finished
		if btplayer and not _is_dead:
			btplayer.restart()
		if hsm and not _is_dead:
			hsm.set_active(true)
	else:
		var btplayer := get_node_or_null(^"BTPlayer") as BTPlayer
		if btplayer:
			btplayer.set_active(false)
		var hsm := get_node_or_null(^"LimboHSM")
		if hsm:
			hsm.set_active(false)
		if btplayer and not _is_dead:
			btplayer.restart()
		if hsm and not _is_dead:
			hsm.set_active(true)
			
## Play death animation and spawn minions
func play_death_animation_and_summon75() -> void:
	# Play the death animation
	animation_player.play("Phase")  # Make sure the death animation is named correctly
	
	# Spawn three minions in an arc above the boss
	var positions: Array = [
		position + Vector2(50, -50),   # Top-right
		position + Vector2(0, -50),    # Directly above
		position + Vector2(-50, -50)   # Top-left
	]
	
	for pos in positions:
		if is_good_position(pos):
			# Using `call_deferred` ensures this happens safely after the current frame
			call_deferred("summon_minion", pos)  # Safely summon minions after the animation finishes
	await get_tree().create_timer(0.5)
	
func play_death_animation_and_summon50() -> void:
	# Play the death animation
	animation_player.play("Phase")  # Make sure the death animation is named correctly
	
# Spawn five minions in an arc above the boss
	var positions: Array = [
		position + Vector2(100, -50),   # Top-right
		position + Vector2(50, -50),    # Slightly to the right
		position + Vector2(0, -50),     # Directly above
		position + Vector2(-50, -50),   # Slightly to the left
		position + Vector2(-100, -50)   # Top-left
	]
	
	for pos in positions:
		if is_good_position(pos):
			# Using `call_deferred` ensures this happens safely after the current frame
			call_deferred("summon_minion", pos)  # Safely summon minions after the animation finishes
	await get_tree().create_timer(0.7)
	
func play_death_animation_and_summon25() -> void:
	# Play the death animation
	animation_player.play("Phase")  # Make sure the death animation is named correctly
	
# Spawn seven minions in an arc above the boss
	var positions: Array = [
		position + Vector2(120, -50),   # Top-right
		position + Vector2(85, -50),    # Slightly to the right
		position + Vector2(50, -50),    # Right
		position + Vector2(0, -50),     # Directly above
		position + Vector2(-50, -50),   # Left
		position + Vector2(-85, -50),   # Slightly to the left
		position + Vector2(-120, -50)   # Top-left
	]
	
	for pos in positions:
		if is_good_position(pos):
			# Using `call_deferred` ensures this happens safely after the current frame
			call_deferred("summon_minion", pos)  # Safely summon minions after the animation finishes
	await get_tree().create_timer(1)
## Push agent in the knockback direction for the specified number of physics frames.
func apply_knockback(knockback: Vector2, frames: int = 10) -> void:
	if knockback.is_zero_approx():
		return
	for i in range(frames):
		move(knockback)
		await get_tree().physics_frame
	#pass


func die() -> void:
	if _is_dead:
		return
	death.emit()
	_is_dead = true
	sprite_2d.process_mode = Node.PROCESS_MODE_DISABLED
	animation_player.play("Death")
	#collision_shape_2d.set_deferred("disabled", true)
	self.collision_layer = 0
	self.collision_mask = 1
	for child in get_children():
		if child is BTPlayer or child is LimboHSM:
			child.set_active(false)
	RewardController.show_reward_screen()
	if get_tree():
		await get_tree().create_timer(10.0).timeout
		queue_free()


func get_health() -> Health:
	return health

func summon_minion(p_position: Vector2) -> void:
	var minion: CharacterBody2D = load(MINION_RESOURCE).instantiate()
	get_parent().add_child(minion)
	minion.position = p_position
