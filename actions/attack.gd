extends "res://actions/action.gd"
class_name Attack

@export var base_damage: int = 5

func _init():
	action_name = 'Attack'
	description = 'Strike the Enemy'

func execute(source, target):
	var modified_damage = max(0, source.strength + base_damage)
	await target.take_damage(modified_damage)
		
