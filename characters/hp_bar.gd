extends ProgressBar

@onready var player = $".."
@onready var sprite: Node2D = null

func _ready() -> void:
	sprite = player.find_child("AnimatedSprite2D", true, false)

	size = Vector2(50, 8)
	value = player.hp
	max_value = player.max_hp
	_update_position()

func _process(_delta: float) -> void:
	value = player.hp
	_update_position()

func _update_position() -> void:
	if sprite:

		position = Vector2(-size.x / 2, sprite.sprite_frames.get_frame_texture(sprite.animation, 0).get_height() * sprite.scale.y / 2 + 10)
		
		
