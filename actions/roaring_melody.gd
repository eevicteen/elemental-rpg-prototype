extends "res://actions/action.gd"
class_name RoaringMelody

@export var base_damage: int = 10

func _init():
	action_name = 'Roaring Melody'

func execute(source, target):
	if source.has_node("AnimatedSprite2D"):
		var sprite = source.get_node("AnimatedSprite2D")
		if sprite.sprite_frames.has_animation("roaring_melody"): 
			sprite.play("roaring_melody")
			await sprite.animation_finished 
			if sprite.sprite_frames.has_animation("default"):
				sprite.play("default") 
		else:
			push_warning("Animation 'roaring_melody' not found on " + source.char_name)
	else:
		push_warning("No AnimatedSprite2D found on " + source.char_name)

	var modified_damage = source.magic + base_damage
	await target.take_damage(modified_damage)
