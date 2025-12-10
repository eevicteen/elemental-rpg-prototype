extends PanelContainer

@onready var item_set = $MarginContainer/MenuVBox/InventorySet

func _ready() -> void:
	var card_stylebox = StyleBoxFlat.new()
	card_stylebox.set_border_width_all(5)

	for item in GameState.inventory:
		var item_data = GameState.inventory[item]

		var item_card_panel = PanelContainer.new()
		item_card_panel.add_theme_stylebox_override("panel", card_stylebox)
		item_card_panel.set_h_size_flags(Control.SIZE_EXPAND_FILL) 
		var item_card = VBoxContainer.new()
		item_card_panel.add_child(item_card)

		var name_label = Label.new()
		name_label.text = item
		name_label.add_theme_font_size_override("font_size", 24)
		name_label.add_theme_color_override("font_color", Color.WHITE)
		name_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER) 
		item_card.add_child(name_label)
		
		var h_separator = HSeparator.new()
		h_separator.set_custom_minimum_size(Vector2(0, 3)) 
		item_card.add_child(h_separator)

		for stat in item_data:
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
			stat_value_label.text = str(item_data[stat])
			stat_value_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_RIGHT)
			stat_line.add_child(stat_value_label)
			
			var margin_card = MarginContainer.new()
			margin_card.add_theme_constant_override("margin_left", 8)
			margin_card.add_theme_constant_override("margin_bottom", 5)
			margin_card.add_theme_constant_override("margin_right",8 )
			
			margin_card.add_child(stat_line)
			item_card.add_child(margin_card)
		item_set.add_child(item_card_panel)
	

func _process(delta: float) -> void:
	pass
