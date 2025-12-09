extends "res://actions/action.gd"
class_name HighNoteBlast

@export var base_damage: int = 8

func _init():
	action_name = 'High Note'

func execute(source, target):
	if source.has_node("AnimatedSprite2D"):
		var sprite = source.get_node("AnimatedSprite2D")
		if sprite.sprite_frames.has_animation("high_note"):
			sprite.play("high_note")
			await sprite.animation_finished  
			sprite.play("default")  
		else:
			push_warning("Animation not found on " + source.char_name)
	else:
		push_warning("No AnimatedSprite2D found on " + source.char_name)
		
	var modified_damage = source.magic + base_damage
	await target.take_damage(modified_damage)
