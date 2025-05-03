extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera2D = $Camera2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt: AudioStreamPlayer2D = $Hurt

signal player_died

var _moved_this_frame: bool = false
var _is_dead: bool = false
@export_category("Camera Settings")
@export var left: int = -10000000
@export var right: int = 10000000
@export var top: int = -10000000
@export var bottom: int = 10000000
@export var camera_zoom_x: float = 3.0
@export var camera_zoom_y: float = 3.0
@export var camera_x_transform: float = 0
@export var camera_y_transform: float = 0 
@export var inventory: Inventory
@export var base_damage: int = 0
@onready var health: Health = $Health

var reward_node = get_node
func _ready() -> void:
	camera.limit_bottom = bottom
	camera.limit_top = top
	camera.limit_left = left
	camera.limit_right = right
	camera.zoom.x = camera_zoom_x
	camera.zoom.y = camera_zoom_y
	camera.position.x = camera_x_transform
	camera.position.y = camera_y_transform
	SaveController.connect("PotionAdded", Callable(self, "_on_potion_added"))
	
	$Health.connect("death", Callable(self, "_on_player_death"))

func _process(delta: float) -> void:
	if _is_dead:
		return


func die() -> void:
	if _is_dead:
		return
	_is_dead = true
	animation_player.play("death")
	player_died.emit()
	set_physics_process(false) # stop moving after death

#func receives_knockback(damage_source_pos: Vector2, received_damage: int):
	#pass
func apply_knockback(knockback: Vector2, frames: int = 10) -> void:
	if knockback.is_zero_approx():
		return
	for i in range(frames):
		move(knockback)
		await get_tree().physics_frame

func move(p_velocity: Vector2) -> void:
	velocity = lerp(velocity, p_velocity, 0.2)
	move_and_slide()
	_moved_this_frame = true

func get_facing() -> float:
	return 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		area.collect(inventory)
		
func _on_potion_added() -> void:
	update_damage()
	update_health()
	update_stamina()
	update_speed()
	update_jump()
	
func update_damage() -> void:
	var strPotions = SaveController.getPotionCount("Elixir of Strength")
	$Sprite2D/Hitbox.damage = $Sprite2D/Hitbox.damage + strPotions
	$Sprite2D/LightHitbox.damage = $Sprite2D/LightHitbox.damage + strPotions

func update_health() -> void:
	var healthPotions = SaveController.getPotionCount("Elixir of Fortitude")
	$Health.max_health = $Health.max_health + 2*(healthPotions)
	var current_health = $Health.get_current()+2
	$Camera2D/StatusUI.set_max_health($Health.max_health)
	$Camera2D/StatusUI.update_health(current_health)
	health._current = current_health
	
	
func update_stamina() -> void:
	var staminaPotions = SaveController.getPotionCount("Elixir of Stamina")
	$Stamina.max_stamina = $Stamina.max_stamina + staminaPotions
	
	
func update_speed() -> void:
	var speedPotions = SaveController.getPotionCount("Elixir of Swiftness")
	if speedPotions > 0:
		$StateMachine/Run.speed *= (1.1 ** speedPotions)
		$StateMachine/Run.max_horizontal_speed *= (1.1 ** speedPotions)
	
func update_jump() -> void:
	var jumpPotions = SaveController.getPotionCount("Elixir of Jumping")
	if jumpPotions > 0:
		$StateMachine/Jump.jump_power *= (1.1 ** jumpPotions)

func _start_invincibility():
	if _is_dead:
		return
	hurt.play()
	# Don't restart if already blinking
	if get_node("Sprite2D").modulate.a < 1.0:
		return

	var sprite := $Sprite2D
	var hurtbox := $Sprite2D/Hurtbox

	# Disable hurtbox shapes
	for shape in hurtbox.get_children():
		if shape is CollisionShape2D:
			shape.set_deferred("disabled", true)

	var original_color := Color(1, 1, 1, 1)
	var transparent := Color(1, 1, 1, 0)
	var blink_duration := 1
	var blink_interval := 0.2
	var blink_timer := 0.0

	# Coroutine-style blink loop
	await get_tree().process_frame
	while blink_timer < blink_duration:
		sprite.modulate = transparent
		await get_tree().create_timer(blink_interval / 2).timeout
		sprite.modulate = original_color
		await get_tree().create_timer(blink_interval / 2).timeout
		blink_timer += blink_interval

	# Ensure visibility and re-enable hurtbox
	sprite.modulate = original_color
	for shape in hurtbox.get_children():
		if shape is CollisionShape2D:
			shape.set_deferred("disabled", false)

func _on_player_death() -> void:
	if _is_dead:
		return

	_is_dead = true
	player_died.emit()


	# Option B: Transition to a Death state
	$StateMachine.transition_to("DeathState")
	
