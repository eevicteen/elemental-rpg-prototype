extends "res://actions/action.gd"
class_name HealAction

func _init():
	action_name = "Heal"
	description = "Restore 5 HP."
	is_heal = true
	heal_amount = 5
	
func execute(source, target):
	await source.heal(heal_amount)
	
