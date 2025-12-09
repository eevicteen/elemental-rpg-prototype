extends CanvasLayer

@onready var mainmenu_path = "res://ui/overworld_menu.tscn"
var current_menu: Control
var char_menu = "res://ui/character_screen.tscn"
var char_button

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu_open"):
		_open_menu(mainmenu_path)
		
	if Input.is_action_just_pressed("menu_close"):	
		_close_current_menu()
	
func _on_character_select():
	_open_menu(char_menu)

func _close_current_menu():
	if current_menu:
		print(current_menu)
		current_menu.queue_free()


func _open_menu(menu_path):
	_close_current_menu()
	current_menu = load(menu_path).instantiate()
	add_child(current_menu)
	if menu_path == mainmenu_path:
		var char_button_path = "MarginContainer/MenuVBox/Buttons/CharButton" 
		var char_button = current_menu.get_node(char_button_path)
		char_button.pressed.connect(Callable(self, "_on_character_select")) 
