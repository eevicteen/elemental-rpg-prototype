extends CanvasLayer

@onready var mainmenu_path = "res://ui/overworld_menu.tscn"
@onready var player = $"../Overworld/PlayerOverworld"
var current_menu: Control
var char_menu = "res://ui/character_screen.tscn"
var inv_menu = "res://ui/inventory_screen.tscn"


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu_open"):
		open_menu(mainmenu_path)
		player.can_move = false
		
	if Input.is_action_just_pressed("menu_close"):	
		_close_current_menu()
		player.can_move = true

	
func _on_character_select():
	open_menu(char_menu)
	
func _on_inventory_select():
	open_menu(inv_menu)


func _close_current_menu():
	if current_menu:
		current_menu.queue_free()


func open_menu(menu_path, char=null):
	_close_current_menu()
	current_menu = load(menu_path).instantiate()
	if char != null:
		current_menu.char = char
	
	add_child(current_menu)
	
	if menu_path == mainmenu_path:
		var char_button_path = "MarginContainer/MenuVBox/Buttons/CharButton" 
		var char_button = current_menu.get_node(char_button_path)
		char_button.pressed.connect(Callable(self, "_on_character_select")) 
		var inv_button_path = "MarginContainer/MenuVBox/Buttons/InvButton" 
		var inv_button = current_menu.get_node(inv_button_path)
		inv_button.pressed.connect(Callable(self, "_on_inventory_select")) 
		
