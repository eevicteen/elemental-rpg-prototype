extends Node2D
class_name Character

signal turn_finished
signal text_emitted(text: String)

# Character stats
@export var char_name: String = "Unnamed"
@export var max_hp: int = 100
@export var hp: int = 100
@export var strength: int = 5
var strength_buffs:= 0
var magic_buffs:=0
var speed_buffs:= 0
@export var magic: int = 5
@export var speed: int = 10
@export var is_enemy: bool = false
@export var is_defending: bool = false

@onready var animator: AnimationPlayer = null
@onready var healthbar: ProgressBar = null
@onready var skills
@onready var sprite: AnimatedSprite2D = null
# Assuming these are direct children of Character (Node2D)
@onready var aura_sprite: AnimatedSprite2D = $AuraSprite
@onready var aura_gauge_display: Label = $AuraGaugeDisplay 
@onready var turn_queue = get_parent()

var charge_countdown = 0
var charged_action = null
var charged_target = null

var aura = "none"
var aura_gauge = 0

var buff_list = []

# --- Custom Aura Offsets (Local to the Character) ---
const AURA_X_OFFSET = -30 
const AURA_Y_OFFSET = -40 


func _ready() -> void:
	pass
	
# Turn execution
func play_turn(target, action) -> void:
	$AnimatedSprite2D.modulate = Color.WHITE
	is_defending = false
	handle_damage_buffs()
	emit_signal("text_emitted", char_name + " is taking a turn...")
	await get_tree().create_timer(1).timeout
	if sprite:
		sprite.play(action.action_name)
	
	if action.is_charge:
		if charge_countdown < action.charge_time:
			$AnimatedSprite2D.modulate = Color.YELLOW
			emit_signal("text_emitted", char_name + " is charging up...")
			await get_tree().create_timer(1).timeout
			emit_signal("text_emitted", str(action.charge_time - charge_countdown) + " turns left to charge")
			charge_countdown += 1
			charged_action = action
			charged_target = target
		else:
			action.execute(self, target)
			charged_action = null
			charge_countdown = 0
			charged_target = null
		await get_tree().create_timer(1.5).timeout
		emit_signal("turn_finished") # Add turn_finished signal here
		return
	
	if action.is_teamwide:
		for char in turn_queue.hero_list:
			await _perform_action(action, char)
	else:
		await _perform_action(action,target)
	
	emit_signal("text_emitted", char_name + " finished turn.")
	await get_tree().create_timer(1).timeout
	emit_signal("turn_finished")


# Damage handling
func take_damage(amount: int) -> void:
	if is_defending:
		amount = amount / 2
		emit_signal("text_emitted", char_name + " is defending! Damage is halved.")
		await get_tree().create_timer(1).timeout
	amount = max(0, amount)
	hp = clamp(hp - amount, 0, max_hp)
	emit_signal("text_emitted", char_name + " takes " + str(amount) + " damage. HP: " + str(hp))
	await get_tree().create_timer(1.5).timeout
	if healthbar:
		healthbar.value = hp
	if hp <= 0:
		die()


func _perform_action(action,target):
	if action.is_item_action:
		emit_signal("text_emitted", char_name + action.action_name)
	else:
		emit_signal("text_emitted", char_name + " is performing " + action.action_name)
	
	await get_tree().create_timer(1).timeout
	await action.execute(self, target)


func defend():
	is_defending = true
	$AnimatedSprite2D.modulate = Color.SKY_BLUE
	

func die() -> void:
	emit_signal("text_emitted", char_name + " has fallen!")
	await get_tree().create_timer(3.0).timeout
	
	
func heal(heal_amount):
	var new_hp = min(hp + heal_amount, max_hp)
	var diff = new_hp - hp
	hp = new_hp
	emit_signal("text_emitted", 'Healed for ' + str(diff))
	await get_tree().create_timer(1.0).timeout
	if healthbar:
		healthbar.value = hp


func buff(type,amount,duration):
	buff_list.append([type,amount,duration])
	emit_signal("text_emitted", char_name + "'s " + type + " has been buffed by " + str(amount) + " for " + str(duration) + " turns." )
	await get_tree().create_timer(1.0).timeout
	
	
func handle_damage_buffs():
	strength_buffs = 0
	magic_buffs = 0
	var buffs_to_remove = []
	
	for buff in buff_list:
		buff[2] -= 1
		if buff[2] < 0:
			buffs_to_remove.append(buff)
			continue
		if buff[0] == 'strength':
			strength_buffs += buff[1]
		elif buff[0] == 'magic':
			magic_buffs += buff[1]
		else:
			continue
		
		
	for expired_buff in buffs_to_remove:
		buff_list.erase(expired_buff)
	

func handle_speed_buffs():
	speed_buffs = 0
	for buff in buff_list:
		if buff[0] == 'speed':
			speed_buffs += buff[1]
		else:
			continue
		if buff[2] <= 0:
			buff_list.erase(buff)
			continue	
		buff[2] -= 1


func apply_element(element, gauge, damage, source_magic):
	var reaction_damage = damage
	if aura == "none":
		aura = element
		aura_gauge = gauge
		update_aura_display(aura, aura_gauge)
		return reaction_damage
	var reaction_key = element + ' on ' + aura
	match reaction_key:
		'Hydro on Pyro':
			reaction_damage *= 1.5
			aura_gauge -= 2*gauge
			emit_signal("text_emitted", "Strong Vaporize! Damage increased by 50%." )
			await get_tree().create_timer(1.0).timeout
		'Pyro on Hydro':
			reaction_damage *= 1.2
			print(aura_gauge)
			print(gauge)
			aura_gauge -= 0.5*gauge
			
			print('Guage: ' + str(aura_gauge))
			emit_signal("text_emitted", "Reverse Vaporize! Damage increased by 20%." )
			await get_tree().create_timer(1.0).timeout
		'Electro on Hydro', 'Hydro on Electro':
			pass #addd damage over time effect
		'Pyro on Electro', 'Electro on Pyro':
			#await trigger_transformative_damage(source.magic)
			aura_gauge -= gauge
		_:
			aura_gauge = clamp(aura_gauge+gauge,0,4)
	if aura_gauge <= 0:
		aura_gauge = 0
		aura = 'none'
	update_aura_display(aura,aura_gauge)	
	return reaction_damage
	
func update_aura_display(element,gauge):
	
	if aura == 'none':
		if is_instance_valid(aura_sprite):
			aura_sprite.hide()
		if is_instance_valid(aura_gauge_display):
			aura_gauge_display.hide()
	else:
		if is_instance_valid(aura_sprite) and is_instance_valid(aura_gauge_display):
			aura_sprite.show()
			aura_gauge_display.show()
			aura_sprite.play(element)
			aura_gauge_display.text = str(aura_gauge)
