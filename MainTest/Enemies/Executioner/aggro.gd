extends NodeStateBat

@export var character_body_2d : CharacterBody2D
@export var speed : int = 100  # Ensure a reasonable default speed
@onready var bat_aggro: AudioStreamPlayer2D = $"../../batAggro"
@onready var navigation_agent_2d: NavigationAgent2D = $"../../NavigationAgent2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var player : CharacterBody2D
var max_speed : int
var first_time = true
var is_playing = false

func on_physics_process(delta : float):
	if navigation_agent_2d.is_navigation_finished() and \
			player.global_position.distance_to(navigation_agent_2d.target_position) < 1.0:
		return

	navigation_agent_2d.target_position = player.global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()


	character_body_2d.velocity = character_body_2d.global_position.direction_to(next_path_position) * speed

	character_body_2d.move_and_slide()
		
func enter():
	animation_player.play("Idle")
	if first_time:
		player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
		max_speed = speed + 20
		first_time = false

func exit():
	pass
