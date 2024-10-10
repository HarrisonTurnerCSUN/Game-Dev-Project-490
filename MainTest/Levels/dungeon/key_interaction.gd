extends Area2D

var key_grabbed = false
var player_near_key = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_near_key and Input.is_action_just_pressed("interact") and not key_grabbed:
		grab_key()  # Grab the key if player presses the interact button and hasn't grabbed it yet


func _on_body_entered(body):
	if body.name == "Player":  # Check if the player entered the key's area
		player_near_key = true
		print("Player is near the key. Press 'interact' to grab it.")

func grab_key():
	key_grabbed = true  # Mark the key as grabbed
	$Sprite.visible = false  # Hide the key sprite to simulate being picked up
	print("Player grabbed the key!")
