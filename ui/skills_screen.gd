extends PanelContainer

@onready var skills_set = $MarginContainer/MenuVBox/SkillsSet
var char

func _ready() -> void:
	var card_stylebox = StyleBoxFlat.new()
	card_stylebox.set_border_width_all(5)

	for skill in char.skills:
		var skill_card_panel = PanelContainer.new()
		skill_card_panel.add_theme_stylebox_override("panel", card_stylebox)
		skill_card_panel.set_h_size_flags(Control.SIZE_EXPAND_FILL) 
		var skill_card = VBoxContainer.new()
		skill_card_panel.add_child(skill_card)

		var name_label = Label.new()
		name_label.text = skill.action_name
		name_label.add_theme_font_size_override("font_size", 24)
		name_label.add_theme_color_override("font_color", Color.WHITE)
		name_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER) 
		skill_card.add_child(name_label)
		
		var h_separator = HSeparator.new()
		h_separator.set_custom_minimum_size(Vector2(0, 3)) 
		skill_card.add_child(h_separator)
		
		var desc_label = Label.new()
		desc_label.text = skill.description
		desc_label.add_theme_color_override("font_color", Color.WHITE)
		desc_label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		desc_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_LEFT)
		desc_label.set_autowrap_mode(TextServer.AUTOWRAP_WORD) 
		skill_card.add_child(desc_label)
		
		var skill_line = HBoxContainer.new()
		var skill_value_label = Label.new()
		if skill.is_heal:
			skill_value_label.text = "Heal Amount: " + str(skill.heal_amount)
		elif skill.buff_action != null:
			skill_value_label.text = "Buff Amount: " + str(skill.buff_amount)
		else:
			var add_on : String
			if skill.is_magic: add_on = " + MAG"
			else: add_on = " + STR"
			skill_value_label.text = "Damage: " + str(skill.base_damage) + add_on
			
		skill_value_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_RIGHT)
		skill_line.add_child(skill_value_label)
		
		skill_card.add_child(skill_line)
		
		var margin_card = MarginContainer.new()
		margin_card.add_theme_constant_override("margin_left", 8)
		margin_card.add_theme_constant_override("margin_bottom", 5)
		margin_card.add_theme_constant_override("margin_right",8 )
			
		margin_card.add_child(skill_card)
		
		skill_card.add_child(margin_card)
		skills_set.add_child(skill_card_panel)
	

func _process(delta: float) -> void:
	pass
