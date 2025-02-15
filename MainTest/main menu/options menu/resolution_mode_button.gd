extends Control

@onready var res_Button = $HBoxContainer/OptionButton as OptionButton
# Called when the node enters the scene tree for the first time.
var resolutions : Dictionary = {"3840x2160":Vector2i(3840,2160),
								"2560x1440":Vector2i(2560,1440),
								"1920x1080":Vector2i(1920,1080),
								"1600x900":Vector2i(1600,900),
								"1536x864":Vector2i(1536,864),
								"1440x900":Vector2i(1440,900),
								"1360x768":Vector2i(1360,768),
								"1280x720":Vector2i(1280,720),
								"1024x600":Vector2i(1024,600),
								"800x600":Vector2i(800,600)}


func _ready() -> void:
	add_resolutions();


func add_resolutions() -> void:
	var current = get_window().get_size()
	var i = 0
	for res in resolutions:
		res_Button.add_item(res,i)
		if resolutions[res] == current:
			res_Button.select(i)
		i += 1

func _on_option_button_item_selected(index: int) -> void:
	var size = resolutions.get(res_Button.get_item_text(index))
	DisplayServer.window_set_size(size)
	
	screen_center()

func screen_center() -> void:
	var center_screen = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	
	get_window().set_ime_position(center_screen-window_size/2)
