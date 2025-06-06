extends Control


@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const WINDOW_MODE_ARRAY: Array[String]= [
	"Full-Screen",
	"Window Mode"
]




func _ready():
	add_window_mode_items()
	option_button.item_selected.connect(on_window_mode_selected)
	
	# makes it so button selection indicator is correct
	if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_FULLSCREEN:
		option_button.selected = 0
	else :
		option_button.selected = 1
	print(option_button.selected)

	
func add_window_mode_items()-> void:
	for window_mode in WINDOW_MODE_ARRAY:
		option_button.add_item(window_mode)

func on_window_mode_selected(index: int)-> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		1: #Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
			DisplayServer.window_set_size(DisplayServer.window_get_size())
			
	SaveController.setWindowMode(index)
	SaveController.saveGame()
			
