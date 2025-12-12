# Fortissimo.gd
extends "res://characters/character.gd"
class_name Fortissimo

var skill_animations = {
	"Vocal Strike": "attack",
	"High Note": "high_note",
	"Concerto": "concerto"
}

func _ready():
	char_name = "Fortissimo"
	is_enemy = false
	skills = [ preload("res://actions/vocal_strike.gd").new(),
	preload("res://actions/high_note.gd").new(),
	preload("res://actions/concerto.gd").new()]
	global_position = Vector2(196, 401)

func init_character():
	char_name = "Fortissimo"
	is_enemy = false
	skills = [ preload("res://actions/vocal_strike.gd").new(),
	preload("res://actions/high_note.gd").new(),
	preload("res://actions/concerto.gd").new()]
	global_position = Vector2(196, 401)
