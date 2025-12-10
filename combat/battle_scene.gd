extends Node2D

@onready var turn_queue: TurnQueue = $TurnQueue
@onready var battle_text_label = $BattleText
const OVERWORLD_PATH = "res://overworld.tscn"
var overworld_scene: PackedScene
var battle_active := true
var alive_heroes = []
var alive_enemies = []
signal battle_finished


func _ready() -> void:
	print("Battle starting...")
	turn_queue.initialize()
	turn_queue.connect("turn_finished", Callable(self, "_on_turn_finished"))

	await get_tree().process_frame
	await get_tree().process_frame

	var characters = get_tree().get_nodes_in_group("characters")
	for character in turn_queue.get_children():
		if character.has_signal("text_emitted"):
			character.text_emitted.connect(show_battle_text)
		turn_queue.text_emitted.connect(show_battle_text)

	print("Battle in progress...")


func _on_turn_finished():
	if is_battle_over():
		battle_active = false
		print("Battle ended!")
		turn_queue.battle_active = false
		show_results()
		
		call_deferred("_return_to_overworld")

	else:
		print("Continuing battle...")


func is_battle_over() -> bool:
	alive_heroes.clear()
	alive_enemies.clear()
	for char in turn_queue.character_list:
		if !char.is_enemy:
			GameState.hero_data[char.char_name]['hp'] = char.hp
		if char.hp > 0 and char.is_enemy:
			alive_enemies.append(char)
		elif char.hp > 0 and !char.is_enemy:
			alive_heroes.append(char)
			
	return alive_heroes.is_empty() or alive_enemies.is_empty()


func show_results() -> void:
	if alive_heroes.is_empty():
		show_battle_text("The enemies won!")
	else:
		show_battle_text("The heroes won!")
	
		
func show_battle_text(text: String):
	battle_text_label.text = "▶  " + text + "\n"
	await get_tree().create_timer(2.0).timeout
	
	
func _return_to_overworld():
	emit_signal("battle_finished")
	queue_free()
