extends Node2D

@export var s_head: PackedScene
@export var s_body: PackedScene
@export var s_weak_body: PackedScene
@export var s_tail: PackedScene
@export var venom: PackedScene

@export var move_timer: Timer
@onready var hp : HealthComponent = $HealthComponent

var snake: Array = []
var direction = Vector2.DOWN
var direction_map = {
	Vector2.LEFT: "Left",
	Vector2.RIGHT: "Right",
	Vector2.UP: "Up",
	Vector2.DOWN: "Down"
}


# Starting position
var start_pos: Vector2 = Vector2(0, -100)  
var segment_size = 150  
var snake_size = 12

var can_move = true
var can_bite = true
var can_spit = false
var dead = false


func _ready() -> void:
	spawn_snake()
	$CanvasLayer/HealthBarComponent.modulate =  Color(1, 1, 1, 1)
	await get_tree().create_timer(5.0).timeout
	can_spit = true
	
func _snake_move():
	if can_move and not dead:
		# Move body segments to follow the segment in front
		for i in range(snake.size() - 1, 0, -1):
			snake[i].position = snake[i - 1].position
			# Update the direction based on the segment in front
			snake[i].set_meta("direction", snake[i - 1].get_meta("direction"))
			update_direction(snake[i], snake[i - 1].get_meta("direction"))

		# Move head in the direction
		snake[0].position += direction * segment_size
		# Update head direction
		snake[0].set_meta("direction", direction)
		update_direction(snake[0], direction)
		z_indexing()
		
	if (hp.current_health <= (hp.max_health / 4)):
		enter_rage_mode()

func update_direction(segment, new_direction):
	var dir_str = direction_map.get(new_direction, "")
	segment.get_node("AnimatedSprite2D").play(dir_str)


func spawn_snake():
	var pos = start_pos

	# Spawn head
	var head = s_head.instantiate()
	head.position = pos
	head.z_index = snake_size
	add_child(head)
	snake.append(head)

	# Set initial direction for head
	head.set_meta("direction", Vector2.DOWN) # Set initial direction of head
	update_direction(head, Vector2.DOWN)  # Update head's sprite based on its direction
	head.get_node("Hurtbox").health_component = hp
	head.get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)

	pos.y -= segment_size  # Move position for next segment

	# Spawn alternating body segments
	for i in range(snake_size-2):
		var body_part = s_weak_body.instantiate() if (i+1) % 3 == 0 else s_body.instantiate()
		body_part.position = pos
		body_part.z_index = snake_size-1-i
		add_child(body_part)
		snake.append(body_part)
		
		if (i+1) % 3 == 0:
			body_part.get_node("Hurtbox").health_component = hp

		
		body_part.set_meta("direction", Vector2.DOWN)  # Set initial direction of head
		update_direction(body_part, Vector2.DOWN)
		
		pos.y -= segment_size  # Move position

	# Spawn tail
	var tail = s_tail.instantiate()
	tail.position = pos
	tail.z_index = 1
	add_child(tail)
	snake.append(tail)

	# Set initial direction for tail
	tail.set_meta("direction", Vector2.DOWN)  # Set initial direction of head
	update_direction(tail, Vector2.DOWN)  # Update tail's sprite based on its direction

func chase_player(player_position: Vector2):
	if not can_move:
		return
	if dead:
		return
		
	var direction_to_player = player_position - snake[0].global_position
	
	# If the snake is very close, stop moving
	if direction_to_player.length() < segment_size and can_bite:
		bite_attack()
	
	if direction_to_player.length() >= 300 and can_spit:
		spit_attack(player_position)

	var rand_dir = randi() % 16
	if rand_dir == 0:
		direction = Vector2.RIGHT
	elif rand_dir == 1:
		direction = Vector2.LEFT
	elif rand_dir == 2:
		direction = Vector2.DOWN
	elif rand_dir == 3:
		direction = Vector2.UP
	# Snap to cardinal direction
	else:
		if abs(direction_to_player.x) > abs(direction_to_player.y):
			direction = Vector2.RIGHT if direction_to_player.x > 0 else Vector2.LEFT
		else:
			direction = Vector2.DOWN if direction_to_player.y > 0 else Vector2.UP

func z_indexing():
	for i in range(snake.size()):
		snake[i].z_index = snake.size() - i
		
	for i in range(snake.size() - 2):
		if snake[i+1].position.y < snake[i+2].position.y:
			snake[i+1].z_index -= 1
			snake[i + 2].z_index += 1

func bite_attack():
	can_move = false
	can_bite = false
	var dir_str = direction_map.get(direction, "")
	dir_str += '_Bite'
	var anim_player = snake[0].get_node("AnimatedSprite2D/AnimationPlayer")
	anim_player.play(dir_str)
	Wwise.post_event_id(AK.EVENTS.SNAKE_BITE, self)
	await anim_player.animation_finished
	can_move = true
	can_bite = true

func spit_attack(player_position):
	can_move = false
	can_spit = false
	var dir_str = direction_map.get(direction, "")
	var bite_str = dir_str + '_Bite'
	snake[0].get_node("AnimatedSprite2D").play(bite_str)
	await get_tree().create_timer(.5).timeout
	var venom_shot = venom.instantiate()
	Wwise.post_event_id(AK.EVENTS.SNAKE_SPIT, self)
	venom_shot.global_position = snake[0].global_position
	get_tree().current_scene.add_child(venom_shot)
	venom_shot.shoot(player_position)
	await get_tree().create_timer(.5).timeout
	snake[0].get_node("AnimatedSprite2D").play(dir_str)
	await get_tree().create_timer(1.0).timeout
	can_move = true
	await get_tree().create_timer(5.0).timeout
	can_spit = true

	
func enter_rage_mode():
	#for segment in snake:wa
	$MoveTimer.wait_time = .15
	$CanvasLayer/HealthBarComponent.modulate = Color.REBECCA_PURPLE
	snake[0].get_node("AnimatedSprite2D/rager").play("rage_mode")
	snake[0].get_node("AnimatedSprite2D/AnimationPlayer").speed_scale = 2.0

func _on_health_component_death() -> void:
	print(snake[-1].global_position)
	get_parent().get_node("Artifact").global_position = snake[-1].global_position
	dead = true
	can_move = false
	for i in range(10):
		for segment in snake:
			segment.modulate = Color.RED
			await get_tree().create_timer(0.01).timeout
			segment.modulate = Color.WHITE
	queue_free()

func _on_health_component_t_damage(amount: float) -> void:
	for segment in snake:
		segment.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		segment.modulate = Color.WHITE
