extends "res://characters/character.gd"

class_name Poppy

func _ready() -> void:
	is_enemy = true
	char_name = "Poppy"
	skills=[preload("res://actions/rarara.gd").new(),
	preload("res://actions/astral_voice.gd").new(),
	preload("res://actions/defend.gd").new()]
