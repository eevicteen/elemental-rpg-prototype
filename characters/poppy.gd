extends "res://characters/character.gd"

class_name Poppy

func _ready() -> void:
	is_enemy = true
	if healthbar:
		healthbar.rect_position = Vector2(0, 40)
	char_name = "Poppy"
	skills=[preload("res://actions/rarara.gd").new(),
	preload("res://actions/astral_voice.gd").new(),
	preload("res://actions/defend.gd").new()]
	print(char_name, " ready for battle!")
