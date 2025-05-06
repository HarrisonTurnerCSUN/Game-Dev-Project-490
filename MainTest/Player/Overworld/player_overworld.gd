extends CharacterBody2D

@onready var animation_player = $AnimatedSprite2D/AnimationTree

@export var inventory: Inventory
@export var boomerang_scene: PackedScene
@export var boomerang_exists: bool = false
@export var interact_key := "talk"

var nearby_npc: Node = null

func _physics_process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		animation_player.get("parameters/playback").travel("Idle_BlendSpace2D")
	else:
		animation_player.get("parameters/playback").travel("Walk_BlendSpace2D")
		animation_player.set("parameters/Idle_BlendSpace2D/blend_position", velocity)
		animation_player.set("parameters/Walk_BlendSpace2D/blend_position", velocity)

	# Clean up reference if NPC was deleted
	if nearby_npc and not nearby_npc.is_inside_tree():
		nearby_npc = null

func _on_hitbox_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
	elif area.has_method("try_trade"):
		nearby_npc = area

func _on_hitbox_area_exited(area):
	if area == nearby_npc:
		nearby_npc = null

func _input(event):
	if event.is_action_pressed(interact_key) and nearby_npc:
		nearby_npc.try_trade()

	if event.is_action_pressed("throw_boomerang") and boomerang_scene and not boomerang_exists:
		boomerang_exists = true
		var boomerang = boomerang_scene.instantiate()
		get_parent().add_child(boomerang)
		boomerang.global_position = global_position
		var throw_dir = (get_global_mouse_position() - global_position).normalized()
		boomerang.throw(throw_dir, self)

func get_inventory():
	return inventory
