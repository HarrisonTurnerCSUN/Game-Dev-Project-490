extends AnimatableBody2D

var flag : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_stone_door_trigger_1_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("stoneDoor2")
	pass # Replace with function body.


func _on_stone_door_trigger_2_body_entered(body: Node2D) -> void:
	if flag == false:
		$AnimationPlayer.play_backwards("stoneDoor2")
		flag = true
	pass # Replace with function body.
