extends "res://characters/character.gd"

class_name Rocky

func _ready() -> void:
	is_enemy = true
	char_name = "Rocky"
	skills=[preload("res://actions/power_chord.gd").new(),
	preload("res://actions/encore.gd").new(),
	preload("res://actions/defend.gd").new()]
