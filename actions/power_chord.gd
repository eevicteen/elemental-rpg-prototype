extends "res://actions/action.gd"
class_name PowerChord

@export var base_damage: int = 6  

func _init():
	action_name = 'Power Chord'

func execute(source, target):
	if source.has_node("AnimatedSprite2D"):
		var sprite = source.get_node("AnimatedSprite2D")
		if sprite.sprite_frames.has_animation("power_chord"):
			sprite.play("power_chord")
			await sprite.animation_finished 
			sprite.play("default")  
		else:
			push_warning("Animation not found on " + source.char_name)
	else:
		push_warning("No AnimatedSprite2D found on " + source.char_name)
		
	var modified_damage = source.magic + base_damage
	await target.take_damage(modified_damage)
