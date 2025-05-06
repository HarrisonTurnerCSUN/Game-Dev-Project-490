extends Node2D
#code based on devworm godot 4 spawning system tutorial
#modified to interface with game system and meet goals
@onready var menu = $CanvasLayer/InGameMenu
@export var tilemaplayer : TileMapLayer
@export var player : CharacterBody2D
@onready var sceneChangeAnim = $CanvasLayer/SceneTransition

var current_wave: int
var starting_nodes: int
var current_nodes: int
var wave_spawning: bool
var wave_transitioning: bool
var spawning_allowed: bool = false
var door1_open: bool = true
var door2_open: bool = false

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
	#_to_next_wave()
	menu.flip_star1()
	menu.flip_star2()
	menu.flip_star3()
	sceneChangeAnim.play("fadeOut")
	await sceneChangeAnim.animation_finished

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	#var player_tile_data = tilemaplayer.get_cell_tile_data(tilemaplayer.local_to_map(player.position))
	#if player_tile_data:
		#if player_tile_data.get_custom_data("Fluid"): 
			#player.velocity.x = clamp(player.velocity.x, -100, 100)
			#player.velocity.y = clamp(player.velocity.y, -400, 100)
		#if player_tile_data.get_custom_data("Slow"):
			#player.velocity.x = clamp(player.velocity.x, -100, 100)
	current_nodes = get_child_count()
	$CanvasLayer/RoundCount.setText(current_wave)
	if spawning_allowed && !wave_spawning  && current_wave != 6:
		_to_next_wave()
		$CanvasLayer/RoundCount.visible=true
	
	if current_wave >= 6:
		$CanvasLayer/RoundCount.visible=false
		if !door2_open:
			flip_spawning_status()
			$Objects/Tile_Platform_desert2/AnimationPlayer.play("open")
			door2_open = true
	
	if stopwatch.time/60 >= 5:
		menu.flip_star3()
		
	if stopwatch.time/60 >= 10:
		menu.flip_star2()

	
func _to_next_wave() ->void:
	if current_nodes == starting_nodes:
		if current_wave != 0:
			wave_transitioning = true
		#play anims if you want
		wave_spawning = true
		current_wave += 1
		await get_tree().create_timer(0.5).timeout
		prepare_spawn("bats", 2, 2)#type,mult,spawns
		prepare_spawn("eyeball", 1, 2)
		prepare_spawn("goblin", 0.34, 1)
		prepare_spawn("witch", 0.25, 1)
		prepare_spawn("worm", 0.34, 1)
		prepare_spawn("wolf", 0.2, 1)

		print(current_wave)
		
func prepare_spawn(type, multiplier, mob_spawns):
	var mob_count = float(current_wave)*multiplier
	var mob_wait_time:float = 2.0
	var mob_spawn_rounds = (int)(mob_count/mob_spawns)
	spawn_type(type,mob_spawn_rounds,mob_wait_time)
	
func spawn_type(type,mob_spawn_rounds,mob_wait_time):
	if type == "bats":
		if mob_spawn_rounds > 3:
			mob_spawn_rounds = (int)(mob_spawn_rounds/2)
		@warning_ignore("unused_variable")
		var bat_spawn1 = $Enemies/BatSpawn1
		var bat_spawn2 = $Enemies/BatSpawn2
		var bat_spawn3 = $Enemies/BatSpawn3
		@warning_ignore("unused_variable")
		var bat_spawn4 = $Enemies/BatSpawn4
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				#var bat1 = bat_scene.instantiate()#repeat for num of spawn locations
				#bat1.global_position = bat_spawn1.global_position
				var bat2 = bat_scene.instantiate()#repeat for num of spawn locations
				bat2.global_position = bat_spawn2.global_position
				var bat3 = bat_scene.instantiate()#repeat for num of spawn locations
				bat3.global_position = bat_spawn3.global_position
				#var bat4 = bat_scene.instantiate()#repeat for num of spawn locations
				#bat4.global_position = bat_spawn4.global_position
				#add_child(bat1)
				add_child(bat2)
				add_child(bat3)
				#add_child(bat4)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
	elif type == "goblin":
		if mob_spawn_rounds > 3:
			mob_spawn_rounds = (int)(mob_spawn_rounds/3)
		var goblin_spawn1 = $Enemies/GoblinSpawn1
		@warning_ignore("unused_variable")
		var goblin_spawn2 = $Enemies/GoblinSpawn2
		print("goblin")
		print(mob_spawn_rounds)
		print("goblin")
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var goblin1 = goblin_scene.instantiate()
				goblin1.global_position = goblin_spawn1.global_position
				#var goblin2 = goblin_scene.instantiate()
				#goblin2.global_position = goblin_spawn2.global_position
				
				add_child(goblin1)
				#add_child(goblin2)
				
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
	
	elif type == "worm":
		if mob_spawn_rounds > 3:
			mob_spawn_rounds = (int)(mob_spawn_rounds/3)
		@warning_ignore("unused_variable")
		var worm_spawn1 = $Enemies/WormSpawn1
		var worm_spawn2 = $Enemies/WormSpawn2
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				#var worm1 = worm_scene.instantiate()
				#worm1.global_position = worm_spawn1.global_position 
				var worm2 = worm_scene.instantiate()
				worm2.global_position = worm_spawn2.global_position
				
				#add_child(worm1)
				add_child(worm2)
				
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
				
	elif type == "eyeball":
		if mob_spawn_rounds > 3:
			mob_spawn_rounds = (int)(mob_spawn_rounds/2)
		var eyeball_spawn1 = $Enemies/EyeballSpawn1
		var eyeball_spawn2 = $Enemies/EyeballSpawn2
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var eyeball1 = eyeball_scene.instantiate()
				eyeball1.global_position = eyeball_spawn1.global_position
				var eyeball2 = eyeball_scene.instantiate()
				eyeball2.global_position = eyeball_spawn2.global_position
				
				add_child(eyeball1)
				add_child(eyeball2)
				
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
				
	elif type == "witch":
		var witch_spawn = $Enemies/WitchSpawn
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var witch = witch_scene.instantiate()
				witch.global_position = witch_spawn.global_position
				
				add_child(witch)
				
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
				
	elif type == "wolf":
		var wolf_spawn = $Enemies/WolfSpawn
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var wolf = wolf_scene.instantiate()
				wolf.global_position = wolf_spawn.global_position
				
				add_child(wolf)
				
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
	
	wave_spawning = false

func flip_spawning_status()->void:
	spawning_allowed = !spawning_allowed


@warning_ignore("unused_parameter")
func _on_area_2d_body_entered(body: Node2D) -> void:
	if door1_open:
		door1_open = false
		$Objects/Tile_Platform_desert/AnimationPlayer.play("open")
		flip_spawning_status()


@warning_ignore("unused_parameter")
func _on_star_2d_body_entered(body: Node2D) -> void:
	menu.flip_star1()
