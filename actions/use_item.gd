extends Resource
class_name use_item

var action_name = 'Use Item'
var item_name
var target_faction

func execute(source, target, item_instance):
	if source.has_node("AnimatedSprite2D"):
		var sprite = source.get_node("AnimatedSprite2D")
		if sprite.sprite_frames.has_animation("use_item"): 
			sprite.play("use_item")
			await sprite.animation_finished 
			if sprite.sprite_frames.has_animation("default"):
				sprite.play("default") 
