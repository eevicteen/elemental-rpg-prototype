extends "res://actions/action.gd"
class_name HighNoteBlast

func _init():
	action_name = 'High Note'
	description = "Attack the enemy with 8 base magic damage."
	base_damage = 8
	is_magic = true
