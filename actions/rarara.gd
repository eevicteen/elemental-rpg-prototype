extends "res://actions/action.gd"
class_name RaRaRa

@export var base_damage: int = 15

func _init():
	action_name = 'RaRaRa'
	description = "Harness the power of a bad romance."
	
func execute(source, target):
	if source.has_node("AnimatedSprite2D"):
		var sprite = source.get_node("AnimatedSprite2D")
		if sprite.sprite_frames.has_animation("rarara"):
			sprite.play("rarara")
			await sprite.animation_finished  
			sprite.play("default")  
		else:
			push_warning("Animation not found on " + source.char_name)
	else:
		push_warning("No AnimatedSprite2D found on " + source.char_name)
		
	var modified_damage = source.magic + base_damage
	await target.take_damage(modified_damage)
