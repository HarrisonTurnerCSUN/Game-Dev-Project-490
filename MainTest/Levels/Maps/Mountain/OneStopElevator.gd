extends AnimatableBody2D

@onready var isUp = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(func(_anim_name): _set_isUp())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	print("YES")
