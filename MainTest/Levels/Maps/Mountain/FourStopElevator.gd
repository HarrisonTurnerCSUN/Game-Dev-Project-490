extends AnimatableBody2D

@onready var entered = false
@onready var can_process_input = true
@onready var location = 1
@onready var lever = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#entered = false
	#can_process_input = true

func _process(_delta):
	if can_process_input and entered == true:
		if Input.is_action_just_pressed("enter"):
			can_process_input = false
			anim_handler()

func anim_handler():
	match [lever,location]:
		[1,1],[2,2],[3,3]:
			print("Already Home")
		[-1,1],[-1,2],[-1,3]:
			print("Error")
		[1,2]:
			$AnimationPlayer.play_backwards("down1")
			location = 1
		[1,3]:
			$AnimationPlayer.play_backwards("down2")
			$AnimationPlayer.play_backwards("down1")
			location = 1
		[2,1]:
			$AnimationPlayer.play("down1")
			location = 2
		[2,3]:
			$AnimationPlayer.play_backwards("down2")
			location = 2
		[3,1]:
			$AnimationPlayer.play("down1")
			$AnimationPlayer.play("down2")
			location = 3
		[3,2]:
			$AnimationPlayer.play("down2")
			location = 3
		[4,1]:
			$AnimationPlayer.play("down1")
			location = 2
		[4,2]:
			$AnimationPlayer.play("down2")
			location = 3
		[4,3]:
			print("halt")
		[5,1]:
			print("halt")
		[5,2]:
			$AnimationPlayer.play_backwards("down1")
			location = 1
		[5,3]:
			$AnimationPlayer.play_backwards("down2")
			location = 2
			
	can_process_input = true

#lever simplification
func _on_body_entered(_body,lever_id):
	entered = true
	lever = lever_id
	print("entered")
	print(lever)
	
func _on_body_exited(_body):
	entered = false
	lever = -1
	print("exited")
	
