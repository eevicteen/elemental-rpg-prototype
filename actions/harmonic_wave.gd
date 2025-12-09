extends "res://actions/action.gd"
class_name HarmonicWave

@export var base_damage: int = 15

func _init():
	action_name = 'Harmonic Wave'
	is_heal = true

func execute(source, target):
	if source.has_node("AnimatedSprite2D"):
		var sprite = source.get_node("AnimatedSprite2D")
		if sprite.sprite_frames.has_animation("harmonic_wave"):
			sprite.play("harmonic_wave")
			await sprite.animation_finished  
			sprite.play("default")  
		else:
			push_warning("Animation not found on " + source.char_name)
	else:
		push_warning("No AnimatedSprite2D found on " + source.char_name)
		
	var modified_heal = source.magic + base_damage
	await target.heal(modified_heal)
