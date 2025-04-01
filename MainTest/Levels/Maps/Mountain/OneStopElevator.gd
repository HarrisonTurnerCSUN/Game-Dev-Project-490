extends AnimatableBody2D

@onready var isUp = true
@onready var entered = false
@onready var can_process_input = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(func(_anim_name): _set_isUp())
	#entered = false
	#can_process_input = true

func _process(_delta):
	if can_process_input and entered == true:
		if Input.is_action_just_pressed("enter"):
			can_process_input = false
			if isUp:
				$AnimationPlayer.play("Elevator1Down")
			else:
				$AnimationPlayer.play("Elevator1Up")

func _on_body_entered(_body):
	entered = true
	#print("entered") just used to check if the player entered collision

func _on_body_exited(_body):
	entered = false
	#print("exit") just used to check if the player is not in the collision

func _on_lever_1_body_entered(body: Node2D) -> void:
	if isUp:
		$AnimationPlayer.play("Elevator1Down")
	else:
		$AnimationPlayer.play("Elevator1Up")
	

func _on_lever_2_body_entered(body: Node2D) -> void:
	isUp = true
	$AnimationPlayer.play("Elevator1Up")
	
func _set_isUp()->void:
	isUp = !isUp
	can_process_input = true
	print("YES")
