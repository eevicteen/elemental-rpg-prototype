extends "base_item.gd"

func _init() -> void:
	item_name = "Shuriken"
	item_description = "Hit an enemy with 20 attack power."
	stackable = true
	max_stack = 99
	use_action = Attack
	item_degree = 20
