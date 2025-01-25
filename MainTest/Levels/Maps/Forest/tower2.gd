extends AnimatableBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_tower_activation_body_entered(_body: Node2D) -> void:
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("rise2")
	pass # Replace with function body.
