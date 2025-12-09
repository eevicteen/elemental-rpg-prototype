extends CharacterBody2D

const SPEED: float = 20000
var facing_dir: Vector2 = Vector2.RIGHT
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

signal new_battle

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("right"):
		input_vector.x += 1
	if Input.is_action_pressed("left"):
		input_vector.x -= 1
	if Input.is_action_pressed("down"):
		input_vector.y += 1
	if Input.is_action_pressed("up"):
		input_vector.y -= 1

	if input_vector.length() > 0:
		input_vector = input_vector.normalized() * SPEED * delta
		velocity = input_vector
		facing_dir = input_vector.normalized()
		anim_sprite.play()
	else:
		velocity = Vector2.ZERO
		anim_sprite.stop()
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
				
		if is_instance_valid(collider) and collider.is_in_group("enemiesoverworld"):
			collider.queue_free()		
			emit_signal("new_battle")
			return


	
