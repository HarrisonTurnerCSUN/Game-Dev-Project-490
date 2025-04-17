extends Node2D

@onready var menu = $CanvasLayer/InGameMenu
@export var tilemaplayer : TileMapLayer
@export var player : CharacterBody2D

var current_wave: int
var starting_nodes: int
var current_nodes: int
var wave_spawning: bool
var wave_transitioning: bool

@export var bat_scene: PackedScene
@export var goblin_scene: PackedScene
@export var wolf_scene: PackedScene
@export var witch_scene: PackedScene
@export var worm_scene: PackedScene
@export var eyeball_scene: PackedScene
# Called when the node enters the scene tree for the first time.
var stopwatch : Stopwatch
func _ready() -> void:
	stopwatch = get_tree().get_first_node_in_group("Stopwatch")
	current_wave = 0
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	_to_next_wave()
	#menu.flip_star1()
	#menu.flip_star2()
	

func _process(delta: float) -> void:
	#var player_tile_data = tilemaplayer.get_cell_tile_data(tilemaplayer.local_to_map(player.position))
	#if player_tile_data:
		#if player_tile_data.get_custom_data("Fluid"): 
			#player.velocity.x = clamp(player.velocity.x, -100, 100)
			#player.velocity.y = clamp(player.velocity.y, -400, 100)
		#if player_tile_data.get_custom_data("Slow"):
			#player.velocity.x = clamp(player.velocity.x, -100, 100)
	current_nodes = get_child_count()
	print()
	if !wave_spawning:
		_to_next_wave()
	
	if stopwatch.time/60 >= 5:
		menu.flip_star3()
		
	if stopwatch.time/60 >= 10:
		menu.flip_star2()
	
	if stopwatch.time/60 >= 15:
		menu.flip_star1()

	
func _to_next_wave() ->void:
	if current_nodes == starting_nodes:
		if current_wave != 0:
			wave_transitioning = true
		#play anims if you want
		wave_spawning = true
		current_wave += 1
		await get_tree().create_timer(0.5).timeout
		prepare_spawn("bats", 4, 4)#type,mult,spawns
		print(current_wave)
		
func prepare_spawn(type, multiplier, mob_spawns):
	var mob_count = float(current_wave)*multiplier
	var mob_wait_time:float = 2.0
	var mob_spawn_rounds = mob_count/mob_spawns
	spawn_type(type,mob_spawn_rounds,mob_wait_time)
	
func spawn_type(type,mob_spawn_rounds,mob_wait_time):
	if type == "bats":
		var bat_spawn1 = $Enemies/BatSpawn1
		var bat_spawn2 = $Enemies/BatSpawn2
		var bat_spawn3 = $Enemies/BatSpawn3
		var bat_spawn4 = $Enemies/BatSpawn4
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var bat1 = bat_scene.instantiate()#repeat for num of spawn locations
				bat1.global_position = bat_spawn1.global_position
				var bat2 = bat_scene.instantiate()#repeat for num of spawn locations
				bat2.global_position = bat_spawn2.global_position
				var bat3 = bat_scene.instantiate()#repeat for num of spawn locations
				bat3.global_position = bat_spawn3.global_position
				var bat4 = bat_scene.instantiate()#repeat for num of spawn locations
				bat4.global_position = bat_spawn4.global_position
				add_child(bat1)
				add_child(bat2)
				add_child(bat3)
				add_child(bat4)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
	elif type == "goblin":
		print()
	
	wave_spawning = false
	
