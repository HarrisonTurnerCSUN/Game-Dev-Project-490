extends TileMapLayer

@onready var entered = false
@onready var can_process_input = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if can_process_input and entered == true:
		if Input.is_action_just_pressed("enter"):
			can_process_input = false
			shatter_wall()

func _on_body_entered(_body):
	entered = true
	#print("entered") just used to check if the player entered collision

func _on_body_exited(_body):
	entered = false
	
func shatter_wall()->void:
	queue_free()
