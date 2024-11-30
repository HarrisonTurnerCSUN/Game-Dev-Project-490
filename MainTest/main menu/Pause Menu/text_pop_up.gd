extends Node2D

@export_multiline var text : String
@onready var label : Label = $VBoxContainer/RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = text
	pass # Replace with function body.
