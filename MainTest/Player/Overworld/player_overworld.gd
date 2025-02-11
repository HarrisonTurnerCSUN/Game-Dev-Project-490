extends CharacterBody2D

@onready var animation_player = $AnimatedSprite2D/AnimationTree

func _physics_process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		animation_player.get("parameters/playback").travel("Idle_BlendSpace2D")
	else:
		animation_player.get("parameters/playback").travel("Walk_BlendSpace2D")
		animation_player.set("parameters/Idle_BlendSpace2D/blend_position",velocity)
		animation_player.set("parameters/Walk_BlendSpace2D/blend_position",velocity)

@export var inventory: Inventory

func _on_hitbox_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)

@export var boomerang_scene: PackedScene
@export var boomerang_exists: bool = false

func _input(event):
	if event.is_action_pressed("throw_boomerang") and boomerang_scene and not boomerang_exists:
		boomerang_exists = true
		var boomerang = boomerang_scene.instantiate()
		get_parent().add_child(boomerang)
		boomerang.global_position = global_position  # Ensure it spawns at the player
		var throw_dir = (get_global_mouse_position() - global_position).normalized()
		boomerang.throw(throw_dir, self)
