extends PanelContainer

@onready var char_set = $MarginContainer/MenuVBox/CharacterSet
var skill_menu_path = "res://ui/skills_screen.tscn"

func _ready() -> void:
	var card_stylebox = StyleBoxFlat.new()
	card_stylebox.set_border_width_all(5)

	for char in GameState.hero_data:
		var hero_data = GameState.hero_data[char]

		var character_card_panel = PanelContainer.new()
		character_card_panel.add_theme_stylebox_override("panel", card_stylebox)
		character_card_panel.set_h_size_flags(Control.SIZE_EXPAND_FILL) 
		var character_card = VBoxContainer.new()
		character_card_panel.add_child(character_card)

		var name_label = Label.new()
		name_label.text = char
		name_label.add_theme_font_size_override("font_size", 24)
		name_label.add_theme_color_override("font_color", Color.WHITE)
		name_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER) 
		character_card.add_child(name_label)
		
		var h_separator = HSeparator.new()
		h_separator.set_custom_minimum_size(Vector2(0, 3)) 
		character_card.add_child(h_separator)

		for stat in hero_data:
			if stat == "scene":
				continue
			
			var stat_line = HBoxContainer.new()
			var stat_name_label = Label.new()
			stat_name_label.text = stat + ":"
			stat_name_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
			stat_name_label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
			stat_name_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_LEFT)
			stat_line.add_child(stat_name_label)
			
			var stat_value_label = Label.new()
			stat_value_label.text = str(hero_data[stat])
			stat_value_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_RIGHT)
			stat_line.add_child(stat_value_label)
			
			
			
			var margin_card = MarginContainer.new()
			margin_card.add_theme_constant_override("margin_left", 8)
			margin_card.add_theme_constant_override("margin_bottom", 5)
			margin_card.add_theme_constant_override("margin_right",8 )
			
			margin_card.add_child(stat_line)
			character_card.add_child(margin_card)
			
		var skills_button = Button.new()
		var char_instance = hero_data["scene"].instantiate()
		char_instance.init_character()  
		skills_button.pressed.connect(
			Callable(self, "_on_skills_select").bind(char_instance)
		)
		skills_button.text = "Skills"
		skills_button.add_theme_font_size_override("font_size",18)
		skills_button.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
		var transparent_style = StyleBoxEmpty.new()
		skills_button.add_theme_stylebox_override("normal", transparent_style)
		skills_button.add_theme_stylebox_override("hover", transparent_style)
		skills_button.add_theme_stylebox_override("pressed", transparent_style)
		character_card.add_child(skills_button) 
		char_set.add_child(character_card_panel)
	

func _process(delta: float) -> void:
	pass
	
func _on_skills_select(char):
	get_parent().open_menu(skill_menu_path,char)
