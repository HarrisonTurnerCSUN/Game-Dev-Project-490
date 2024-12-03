extends AnimatableBody2D

@export var watchedEnemy : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var call = Callable(self,"open")
	watchedEnemy.connect("death",call)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open() -> void:
	$AnimationPlayer.play("Open")
