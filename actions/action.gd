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

var element := 'Physical'
var element_gauge : int

#Performs the action.
func execute(source, target):
	#Animation
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
	
	#Healing/Buffing action
	if is_heal:
		await target.heal(heal_amount)
	elif buff_action != null:
		await target.buff(buff_action,buff_amount,buff_duration)
	
	#Damage action
	else:
		var initial_damage: int
		var final_damage: int #
		if is_magic:
			initial_damage = source.magic + base_damage + source.magic_buffs
		else:
			initial_damage = source.strength + base_damage + source.strength_buffs
			
		final_damage = initial_damage
			
		if element != 'Physical':
			final_damage = await target.apply_element(element, element_gauge, initial_damage, source.magic)
		await target.take_damage(final_damage)
	
