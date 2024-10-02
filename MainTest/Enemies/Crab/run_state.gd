extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var speed : int
@onready var crab_run: AudioStreamPlayer2D = $"../../crab_run"

var player : CharacterBody2D
var max_speed : int
var first_time = true
var is_playing = false

func on_process(_delta :float):
	pass
	
func on_physics_process(delta :float):
	var direction : int
	
	if character_body_2d.global_position > player.global_position:
		animated_sprite_2d.flip_h = true
		direction = -1
	elif character_body_2d.global_position < player.global_position:
		animated_sprite_2d.flip_h = false
		direction = 1
	animated_sprite_2d.play("run")
	if first_time:
		crab_run.play()
		first_time = false
	if not is_playing:
		crab_run.play()
		is_playing = true

	character_body_2d.velocity.x += direction * speed * delta
	character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_speed, max_speed)
	character_body_2d.move_and_slide()
	
func enter():
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	max_speed = speed + 20
	
func exit():
	pass


func _on_crab_run_finished() -> void:
	is_playing = false
