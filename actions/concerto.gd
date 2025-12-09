extends "res://actions/action.gd"
class_name Concerto

@export var base_damage: int = 40
@export var charge_time: int = 2


func _init():
	is_charge = true
	action_name = "Concerto"
	description = "Charge a powerful attack for two turns before using it."

func execute(source, target):
	if source.has_node("AnimatedSprite2D"):
		var sprite = source.get_node("AnimatedSprite2D")
		if sprite.sprite_frames.has_animation("concerto"):
			sprite.play("concerto")
			await sprite.animation_finished  
			sprite.play("default")  
		else:
			push_warning("Animation not found on " + source.char_name)
	else:
		push_warning("No AnimatedSprite2D found on " + source.char_name)
		
	var modified_damage = source.magic + base_damage
	await target.take_damage(modified_damage)
