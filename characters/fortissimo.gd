# Fortissimo.gd
extends "res://characters/character.gd"
class_name Fortissimo

func _ready():
	char_name = "Fortissimo"
	is_enemy = false
	skills = [ preload("res://actions/vocal_strike.gd").new(),
	preload("res://actions/high_note.gd").new(),
	preload("res://actions/concerto.gd").new()]
	position = Vector2(196, 401)

func init_character():
	char_name = "Fortissimo"
	is_enemy = false
	skills = [ preload("res://actions/vocal_strike.gd").new(),
	preload("res://actions/high_note.gd").new(),
	preload("res://actions/concerto.gd").new()]
