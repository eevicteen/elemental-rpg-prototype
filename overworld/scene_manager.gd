extends Node2D

const BATTLE_PATH = "res://combat/battle_scene.tscn"
@onready var player_node = $Overworld/PlayerOverworld
@onready var overworld_node = $Overworld
@onready var gameui = $GameUI


func _ready() -> void:
	player_node.connect("new_battle", Callable(self,"_on_player_overworld_new_battle"))
	
	
func _on_player_overworld_new_battle() -> void:
	var battle_scene = load(BATTLE_PATH)
	var new_battle = battle_scene.instantiate()
	new_battle.connect("battle_finished", Callable(self, "_on_battle_finished"))
	overworld_node.hide()
	gameui.hide()
	GameState.last_player_position = player_node.global_position
	add_child(new_battle)
	
	
func _on_battle_finished():
	player_node.global_position = GameState.last_player_position
	overworld_node.show()
	gameui.show()
