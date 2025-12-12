extends "res://actions/action.gd"
class_name Concerto

func _init():
	is_charge = true
	charge_time = 2
	action_name = "Concerto"
	description = "Charge a powerful attack for two turns before using it."
	base_damage = 40
	is_magic = true
