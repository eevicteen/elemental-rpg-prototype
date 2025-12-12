extends Resource
class_name Action

@export var action_name := 'Default Action'
@export var description := 'Default Description'

@export var is_charge := false
var charge_time 

@export var is_item_action := false

@export var is_heal := false
var heal_amount

@export var buff_action = null
var buff_amount

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
		pass #create buff function
	else:
		if is_magic:
			await target.take_damage(source.magic + base_damage)
		else:
			await target.take_damage(source.strength + base_damage)
