extends Area2D

@onready var door_sprite = $AnimatedSprite2D
var is_open = false


func _on_body_entered(body):
	if body.is_in_group("Player"):  # Check if the entered body is the player
		if Input.is_action_just_pressed("interact") and not is_open:
			open_door()

func open_door():
	door_sprite.play("open door")  # Play the "open door" animation
	is_open = true
