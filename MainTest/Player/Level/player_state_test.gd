extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera2D = $Camera2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt: AudioStreamPlayer2D = $Hurt
var selected_hotbar_index := -1

signal player_died

var _moved_this_frame: bool = false
var _is_dead: bool = false
var _is_healing := false
var _is_speed_boosted := false

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
	SaveController.getPlayerInventory()
	_on_potion_added()
	$Health.connect("death", Callable(self, "_on_player_death"))

func _process(delta: float) -> void:
	if _is_dead or _is_healing:
		return

	for i in range(6):
		if Input.is_action_just_pressed("hotbar_" + str(i + 1)):
			selected_hotbar_index = i

	if Input.is_action_just_pressed("interact") and selected_hotbar_index != -1:
		use_item_from_slot(selected_hotbar_index)

func die() -> void:
	if _is_dead:
		return
	_is_dead = true
	animation_player.play("death")
	player_died.emit()
	set_physics_process(false)

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
	$Sprite2D/Hitbox.damage += strPotions
	$Sprite2D/LightHitbox.damage += strPotions

func update_health() -> void:
	var healthPotions = SaveController.getPotionCount("Elixir of Fortitude")
	$Health.max_health += 2 * healthPotions
	var current_health = $Health.get_current() + 2
	$Camera2D/StatusUI.set_max_health($Health.max_health)
	$Camera2D/StatusUI.update_health(current_health)
	if health.get_current() <= health.max_health - 2:
		health._current = current_health

func update_stamina() -> void:
	var staminaPotions = SaveController.getPotionCount("Elixir of Stamina")
	$Stamina.max_stamina += staminaPotions

func update_speed() -> void:
	var speedPotions = SaveController.getPotionCount("Elixir of Swiftness")
	if speedPotions > 0:
		$StateMachine/Run.speed *= pow(1.1, speedPotions)
		$StateMachine/Run.max_horizontal_speed *= pow(1.1, speedPotions)

func update_jump() -> void:
	var jumpPotions = SaveController.getPotionCount("Elixir of Jumping")
	if jumpPotions > 0:
		$StateMachine/Jump.jump_power *= pow(1.1, jumpPotions)

func _start_invincibility():
	if _is_dead:
		return
	hurt.play()
	if $Sprite2D.modulate.a < 1.0:
		return

	var sprite := $Sprite2D
	var hurtbox := $Sprite2D/Hurtbox
	for shape in hurtbox.get_children():
		if shape is CollisionShape2D:
			shape.set_deferred("disabled", true)

	var original_color := Color(1, 1, 1, 1)
	var transparent := Color(1, 1, 1, 0)
	var blink_duration := 1.0
	var blink_interval := 0.2
	var blink_timer := 0.0

	await get_tree().process_frame
	while blink_timer < blink_duration:
		sprite.modulate = transparent
		await get_tree().create_timer(blink_interval / 2).timeout
		sprite.modulate = original_color
		await get_tree().create_timer(blink_interval / 2).timeout
		blink_timer += blink_interval

	sprite.modulate = original_color
	for shape in hurtbox.get_children():
		if shape is CollisionShape2D:
			shape.set_deferred("disabled", false)

func _on_player_death() -> void:
	if _is_dead:
		return
	_is_dead = true
	player_died.emit()
	$StateMachine.transition_to("DeathState")

func heal_player(amount: int) -> void:
	_is_healing = true
	$StateMachine.set_physics_process(false)
	animation_player.play("Healing")
	await get_tree().create_timer(0.7).timeout

	health._current = min(health._current + amount, health.max_health)
	$Camera2D/StatusUI.update_health(health._current)

	$StateMachine.set_physics_process(true)
	_is_healing = false

func use_item_from_slot(index: int) -> void:
	if index >= inventory.slots.size():
		return

	var slot = inventory.slots[index]
	if slot.item == null or slot.amount <= 0:
		return

	match slot.item.name:
		"lifepot":
			if health.get_current() < health.max_health:
				heal_player(1)
				slot.amount -= 1
		"staminapotion":
			var stamina = $Stamina
			stamina.set_current_stamina(stamina.get_current_stamina() + 25)
			slot.amount -= 1
		"speedpotion":
			apply_speed_boost()
			slot.amount -= 1

	if slot.amount == 0:
		slot.item = null
	inventory.updated.emit()

func apply_speed_boost():
	if _is_speed_boosted:
		return
	_is_speed_boosted = true

	var run_node = $StateMachine/Run
	var original_speed = run_node.speed
	var original_max = run_node.max_horizontal_speed

	run_node.speed *= 1.3
	run_node.max_horizontal_speed *= 1.3

	await get_tree().create_timer(5.0).timeout

	run_node.speed = original_speed
	run_node.max_horizontal_speed = original_max
	_is_speed_boosted = false
