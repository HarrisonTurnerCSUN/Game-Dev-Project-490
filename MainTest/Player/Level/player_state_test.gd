extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera2D = $Camera2D

var _moved_this_frame: bool = false
var _is_dead: bool = false
@export_category("Camera Settings")
@export var left: int = -10000000
@export var right: int = 10000000
@export var top: int = -10000000
@export var bottom: int = 10000000
@export var camera_zoom_x: float = 3.0
@export var camera_zoom_y: float = 3.0 


func _ready() -> void:
	camera.limit_bottom = bottom
	camera.limit_top = top
	camera.limit_left = left
	camera.limit_right = right
	camera.zoom.x = camera_zoom_x
	camera.zoom.y = camera_zoom_y
	
## When agent is damaged...
func _damaged(_amount: float, knockback: Vector2) -> void:
	apply_knockback(knockback)
	#animation_player.play(&"hurt")
	var btplayer := get_node_or_null(^"BTPlayer") as BTPlayer
	if btplayer:
		btplayer.set_active(false)
	var hsm := get_node_or_null(^"LimboHSM")
	if hsm:
		hsm.set_active(false)
	#await animation_player.animation_finished
	if btplayer and not _is_dead:
		btplayer.restart()
	if hsm and not _is_dead:
		hsm.set_active(true)
		
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
	
