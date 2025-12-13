extends Node2D

const BATTLE_SCENE = preload("res://combat/battle_scene.tscn")
const BATTLE_SCENE_SIZE = Vector2(1152, 648) 

@onready var player_node = $Overworld/PlayerOverworld
@onready var overworld_node = $Overworld
@onready var game_ui = $GameUI 

func _ready() -> void:
	player_node.new_battle.connect(_on_player_overworld_new_battle)
	


func _on_player_overworld_new_battle() -> void:
	var new_battle = BATTLE_SCENE.instantiate()
	var camera_node = player_node.get_node_or_null("Camera2D")
	var camera_center_world_pos: Vector2
	if is_instance_valid(camera_node):
		camera_center_world_pos = camera_node.global_position
	else:
		camera_center_world_pos = player_node.global_position
		
	var offset = BATTLE_SCENE_SIZE / 2
	new_battle.global_position = camera_center_world_pos - offset
	new_battle.battle_finished.connect(_on_battle_finished)
	
	overworld_node.hide()
	game_ui.hide()
	player_node.can_move = false
	GameState.last_player_position = player_node.global_position 

	add_child(new_battle)


func _on_battle_finished():
	player_node.global_position = GameState.last_player_position
	player_node.can_move = true
	overworld_node.show()
	game_ui.show()
