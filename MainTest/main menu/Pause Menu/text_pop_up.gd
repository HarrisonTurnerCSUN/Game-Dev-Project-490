extends Control

@export var text : String
@onready var label : Label = $"MarginContainer/MarginContainer/Label"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = text
	pass # Replace with function body.
