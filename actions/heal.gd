extends "res://actions/action.gd"
class_name HealAction

@export var heal_amount := 5

func _init():
	action_name = "Heal"
	description = "Restore some HP"
	
func execute(source, target):
	await source.heal(heal_amount)
	
