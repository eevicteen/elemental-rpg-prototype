extends ProgressBar
class_name CharacterHealthBar

@onready var character_node = $".."
var vertical_offset: float = 0.0

func _ready() -> void:
	var sprite =  character_node.get_node("AnimatedSprite2D") 
	var aura_sprite =  character_node.get_node("AuraSprite")
	var aura_gauge_display =  character_node.get_node("AuraGaugeDisplay")

	size = Vector2(50, 8)
	max_value = character_node.max_hp
	value = character_node.hp
	

	var texture = sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
	vertical_offset = (texture.get_height() * sprite.scale.y) /2

	position = Vector2(-size.x / 2, vertical_offset) 
	
	aura_sprite.position = position + Vector2(-15,15)
	aura_sprite.scale = Vector2(0.2,0.2)
	aura_gauge_display.position = position + Vector2(-10,20)

func _process(_delta: float) -> void:
	value = character_node.hp


	
