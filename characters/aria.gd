extends "res://characters/character.gd"

class_name Aria

func _ready():
	char_name = "Aria"
	is_enemy = false
	skills=[preload("res://actions/harmonic_wave.gd").new(),
	preload("res://actions/roaring_melody.gd").new(),
	preload("res://actions/moonlight_sonata.gd").new()]
	position = Vector2(366, 347)

func init_character():
	char_name = "Aria"
	is_enemy = false
	skills=[preload("res://actions/harmonic_wave.gd").new(),
	preload("res://actions/roaring_melody.gd").new(),
	preload("res://actions/moonlight_sonata.gd").new()]
