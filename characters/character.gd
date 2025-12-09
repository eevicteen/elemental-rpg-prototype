extends Node2D
class_name Character

signal turn_finished
signal text_emitted(text: String)

# Character stats
@export var char_name: String = "Unnamed"
@export var max_hp: int = 100
@export var hp: int = 100
@export var strength: int = 5
@export var magic: int = 5
@export var speed: int = 10
@export var is_enemy: bool = false
@export var is_defending: bool = false

# Optional nodes
@onready var animator: AnimationPlayer = null
@onready var healthbar: ProgressBar = null
@onready var skills
@onready var sprite: AnimatedSprite2D = null

var charge_countdown = 0
var charged_action = null
var charged_target = null


func _ready() -> void:
	if has_node("AnimatedSprite2D"):
		sprite = $AnimatedSprite2D

	if has_node("HP Bar"):
		healthbar = $"HP Bar"
		healthbar.rect_position = Vector2(0, -40)
		healthbar.max_value = max_hp
		healthbar.value = hp
	add_to_group("characters")


# Turn execution
func play_turn(target, action) -> void:
	$AnimatedSprite2D.modulate = Color.WHITE
	is_defending = false

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
		return

	emit_signal("text_emitted", char_name + " is performing " + action.action_name)
	await get_tree().create_timer(1).timeout
	await action.execute(self, target)

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
