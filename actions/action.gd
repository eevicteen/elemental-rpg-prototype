extends Resource
class_name Action

var action_name := 'Default Action'
var description := 'Default Description'

var is_charge := false
var charge_time: int

var is_item_action := false

var is_heal := false
var heal_amount:int
var buff_action = null
var buff_amount: int
var is_teamwide = false
var buff_duration: int

var is_magic := false
var base_damage

#Performs the action.
func execute(source, target):
	if source.has_node("AnimatedSprite2D"):
		var sprite = source.get_node("AnimatedSprite2D")
		if sprite.sprite_frames.has_animation(action_name):
			sprite.play(action_name)
			await sprite.animation_finished  
			sprite.play("default") 
		else:
			push_warning("Animation not found on " + source.char_name)
	else:
		push_warning("No AnimatedSprite2D found on " + source.char_name)
	
	if is_heal:
		await target.heal(heal_amount)
	elif buff_action != null:
		await target.buff(buff_action,buff_amount,buff_duration)
	else:
		if is_magic:
			await target.take_damage(source.magic + base_damage + source.magic_buffs)
		else:
			await target.take_damage(source.strength + base_damage + source.strength_buffs)
