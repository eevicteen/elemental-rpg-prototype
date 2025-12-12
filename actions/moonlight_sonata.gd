extends "res://actions/action.gd"
class_name MoonlightSonata

func _init():
	action_name = 'Moonlight Sonata'
	description = 'Buff all team member strength for 3 turns'
	buff_action = 'strength'
	buff_amount = 5
	buff_duration = 3
	is_teamwide = true
