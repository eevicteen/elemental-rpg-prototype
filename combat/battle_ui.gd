extends CanvasLayer

@onready var main_panel: Control = $MainPanel
@onready var skill_panel: Control = $SkillPanel
@onready var target_panel: Control = $TargetPanel
@onready var item_panel: Control = $ItemPanel
@onready var turn_queue: Node = $"../TurnQueue"

# Main action buttons
@onready var attack_button: Button = $MainPanel/Attack
@onready var skill_button: Button = $MainPanel/Skill
@onready var heal_button: Button = $MainPanel/Heal
@onready var defend_button: Button = $MainPanel/Defend
@onready var item_button = $MainPanel/Items

@onready var defend_action = preload("res://actions/defend.gd").new()
@onready var heal_action = preload("res://actions/heal.gd").new()
@onready var attack_action = preload("res://actions/attack.gd").new()


var selected_action = null
var selected_target = null
var current_player = null

var is_heal := false

func _ready():
	randomize()

	main_panel.visible = false
	skill_panel.visible = false
	target_panel.visible = false

	# Connect buttons
	attack_button.pressed.connect(_on_attack_pressed)
	skill_button.pressed.connect(_on_skill_pressed)
	heal_button.pressed.connect(_on_heal_pressed)
	defend_button.pressed.connect(_on_defend_pressed)
	item_button.pressed.connect(_on_item_pressed)

	turn_queue.connect("player_turn_started", Callable(self, "_on_player_turn"))

# === When it's a player's turn ===
func _on_player_turn(player):
	current_player = player
	main_panel.visible = true
	skill_panel.visible = false
	target_panel.visible = false

	attack_button.visible = true
	heal_button.visible = true  

func _on_item_pressed():
	main_panel.visible=false
	item_panel.visible = true
	for child in item_panel.get_children():
		child.queue_free()
	
	for item in GameState.inventory:
		var btn = Button.new()
		btn.text = item + ": " + str(GameState.inventory[item]["stack"])
		btn.pressed.connect(func():_on_item_selected(item))
		item_panel.add_child(btn)
		
func _on_item_selected(item):
	print(item)
	var item_new = GameState.inventory[item]["scene"].new()
	selected_action = item_new.use_action.new()
	selected_action.action_name = "Use " + item_new.item_name
	print(selected_action.action_name)
	if selected_action.is_heal:
		selected_action.heal_amount = item_new.item_degree
	else:
		selected_action.base_damage = item_new.item_degree
	GameState.inventory[item]["stack"] -= 1
	GameState.update_inventory()
	item_panel.visible = false
	_show_target_panel()
	
func _on_skill_pressed():
	main_panel.visible = false
	skill_panel.visible = true
	
	#Clear the attack panel
	for child in skill_panel.get_children():
		child.queue_free()
		
	#Construct skill buttons dynamically
	for skill in current_player.skills:
		var btn = Button.new()
		btn.text = skill.action_name
		btn.pressed.connect(
			func():
				_on_skill_selected(skill)
		)
		skill_panel.add_child(btn)

func _on_attack_pressed():
	main_panel.visible = false
	selected_action = attack_action
	_show_target_panel()
	
func _on_heal_pressed():
	# Hide panels since we’re acting immediately
	main_panel.visible = false
	skill_panel.visible = false
	target_panel.visible = false

	turn_queue.player_turn(heal_action,current_player)

func _on_defend_pressed():
	# Hide panels since we’re acting immediately
	main_panel.visible = false
	skill_panel.visible = false
	target_panel.visible = false
	
	turn_queue.player_turn(defend_action,current_player)

func _on_skill_selected(skill):
	selected_action = skill
	skill_panel.visible = false
	_show_target_panel()

# === Target selection ===
func _show_target_panel():
	target_panel.visible = true

	for child in target_panel.get_children():
		child.queue_free()
		
	for char in turn_queue.character_list:
		if char.hp > 0:
			# Healing = target allies; Attacking = target enemies
			if selected_action.is_heal and char.char_name in ["Fortissimo", "Aria"]:
				_add_target_button(char)
			elif not selected_action.is_heal and char.char_name not in ["Fortissimo", "Aria"]:
				_add_target_button(char)

func _add_target_button(char):
	var btn = Button.new()
	btn.text = char.char_name
	btn.pressed.connect(func():
		_on_target_selected(char)
	)

	await get_tree().process_frame

	var sprite: Node = null
	if char.has_node("AnimatedSprite2D"):
		sprite = char.get_node("AnimatedSprite2D")
	elif char.has_node("Sprite2D"):
		sprite = char.get_node("Sprite2D")
	else:
		push_warning("Character %s has no sprite node!" % char.name)
		return

	var sprite_height := 0.0

	# --- Handle AnimatedSprite2D ---
	if sprite is AnimatedSprite2D:
		var frames = sprite.sprite_frames
		if frames and frames.has_animation(sprite.animation):
			var frame_texture = frames.get_frame_texture(sprite.animation, 0)
			if frame_texture:
				sprite_height = frame_texture.get_height() * sprite.scale.y
			else:
				push_warning("AnimatedSprite2D for %s has no frame texture!" % char.name)
		else:
			push_warning("AnimatedSprite2D for %s has no valid animation!" % char.name)

	# Compute button position

	var target_marker = char.get_node_or_null("TargetMarker")
	
	btn.position = target_marker.global_position
	print(target_marker.global_position)
	
	
	
	target_panel.add_child(btn)
	

func _on_target_selected(target):
	target_panel.visible = false
	selected_target = target

	if selected_action and selected_target:
		turn_queue.player_turn(selected_action, selected_target)
		selected_action = null
		selected_target = null
		
