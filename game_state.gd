extends Node

var hero_data = { 
	"Aria": {
		"scene": preload("res://characters/aria.tscn"),
		"max_hp": 120,
		"hp": 120,
		"strength": 500,
		"magic": 50,
		"speed": 12
	},
	"Fortissimo": {
		"scene": preload("res://characters/fortissimo.tscn"),
		"max_hp": 80,
		"hp": 80,
		"strength": 500,
		"magic": 10,
		"speed": 8
	}
}


var last_player_position
