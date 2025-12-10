extends "base_item.gd"

func _init() -> void:
	item_name = "Potion"
	item_description = "Heals an ally for 15HP."
	stackable = true
	max_stack = 99
	use_action = HealAction
	item_degree = 15
