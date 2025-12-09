extends 'res://actions/action.gd'
class_name VocalStrike

@export var base_damage := 5

func _init():
	action_name =  'Vocal Strike'
	
func execute(source, target):
	if source.has_node("AnimatedSprite2D"):
		var sprite = source.get_node("AnimatedSprite2D")
		if sprite.sprite_frames.has_animation("vocal_strike"):  
			sprite.play("vocal_strike")
			await sprite.animation_finished  
			if sprite.sprite_frames.has_animation("default"):
				sprite.play("default")  
		else:
			push_warning("Animation 'roaring_melody' not found on " + source.char_name)
	else:
		push_warning("No AnimatedSprite2D found on " + source.char_name)

	var modified_damage = source.magic + base_damage
	await target.take_damage(modified_damage)
