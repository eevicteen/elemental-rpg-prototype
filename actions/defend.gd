extends "res://actions/action.gd"
class_name Defend

@export var base_damage: int = 10

func _init():
	action_name = 'Defend'
	description = 'Half damage until your next action.'

func execute(source, target):
	source.defend()
