extends CharacterBody2D  # ✅ No changes to movement system

@export var speed: float = 250.0  # Speed when moving
@export var return_speed: float = 300.0  # Speed when returning
@export var max_distance: float = 250.0  # Max distance before returning

var direction: Vector2 = Vector2.ZERO
var start_position: Vector2
var returning: bool = false
var player: Node2D  # Reference to the player

@onready var sprite: Sprite2D = $Sprite2D  # Reference to sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D  # ✅ Keeps collision working

func _ready():
	start_position = global_position  # ✅ Keeps original behavior

func _physics_process(delta):
	sprite.rotation_degrees += 600 * delta  # ✅ Keeps spinning effect

	if not returning:
		var collision = move_and_collide(direction * speed * delta)

		if collision:
			var collider = collision.get_collider()
			print("Boomerang Collided With:", collider)  # ✅ Debugging: Prints everything it touches

			if collider.has_method("collect"):  # ✅ Check if it collides with a potion
				print("Boomerang Hit a Potion!")  
				collider.collect(player.inventory)  # ✅ Try collecting the item
		
			returning = true  # ✅ Keep movement the same

		elif global_position.distance_to(start_position) >= max_distance:
			returning = true
			print("Boomerang Reached Max Distance, Returning...")

	elif returning and player:
		collision_shape.disabled = true  # ✅ Disable collision so it doesn’t get stuck
		var return_dir = (player.global_position - global_position).normalized()
		position += return_dir * return_speed * delta

		# Delete when it reaches the player
		if global_position.distance_to(player.global_position) < 5: 
			print("Boomerang Reached Player - Deleting")
			player.boomerang_exists = false  
			queue_free()

func throw(dir: Vector2, player_ref: Node2D):
	global_position = player_ref.global_position 
	direction = dir.normalized()
	player = player_ref
	returning = false 
	start_position = global_position 
	visible = true
	print("Boomerang Thrown From:", global_position, "| Direction:", direction)
	collision_shape.disabled = false  # ✅ Re-enable collision for next throw


func _on_pickup_area_entered(area):
	if area.has_method("collect"):  # ✅ If it's a collectible (like a potion)
		print("Boomerang Collected a Potion!")
		area.collect(player.inventory)  # ✅ Adds the potion to the player's inventory body.
