extends "res://characters/character.gd"

class_name Aria

func _ready():
	char_name = "Aria"
	is_enemy = false
	skills=[preload("res://actions/harmonic_wave.gd").new(),
	preload("res://actions/roaring_melody.gd").new()]
	print(char_name, " ready for battle!")
	global_position = Vector2(366, 347)

	
