extends Node

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

const GRAVITY : int = 1

func _physics_process(delta):
	character_body_2d.velocity.y += GRAVITY * delta
	
	character_body_2d.move_and_slide()
