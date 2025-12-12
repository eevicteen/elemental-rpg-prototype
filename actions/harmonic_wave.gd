extends "res://actions/action.gd"
class_name HarmonicWave

func _init():
	action_name = 'Harmonic Wave'
	description = 'Heal an ally for 15 base healing.'
	is_heal = true
	heal_amount = 15
