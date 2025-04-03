extends Node2D

@export var s_head: PackedScene
@export var s_head2: PackedScene
@export var s_body: PackedScene
@export var s_weak_body: PackedScene
@export var s_tail: PackedScene

@export var move_timer: Timer
@export var venom_timer: Timer
@onready var hp : HealthComponent = $HealthComponent

var snake: Array = []
var direction = Vector2.LEFT
var direction_map = {
	Vector2.LEFT: "Left",
	Vector2.RIGHT: "Right",
	Vector2.UP: "Up",
	Vector2.DOWN: "Down"
}


# Starting position
var start_pos: Vector2 = Vector2(500, 500)  
var segment_size = 100  
var snake_size = 10

var can_move = true
var can_bite = true
var can_spit = false


func _ready() -> void:
	# Connect the move timer signal
	spawn_snake()
	
	for part in snake:
		#if part.name == "SnakeHead" or part.name == "SnakeBodyWeak":
		if part.name == "SnakeBodyWeak":
			for snake_dir in part.get_children():
				var hurtbox = snake_dir.get_node_or_null("Hurtbox")
				if hurtbox:
					hurtbox.health_component = hp

	
func _snake_move():
	if can_move:
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
		update_direction2(snake[0], direction, true)
		z_indexing()
		if (hp.current_health <= (hp.max_health / 2)):
			enter_rage_mode()

	
	print(hp.current_health)

func update_direction(segment, new_direction):
	# Get the active direction name
	var active_dir = direction_map.get(new_direction, null)
	# Hide all direction sprites and track the active one
	var active_sprite = null
	for dir_name in direction_map.values():
		var sprite = segment.get_node_or_null(dir_name)
		if sprite:
			sprite.visible = (dir_name == active_dir)
			if dir_name == active_dir:
				active_sprite = sprite

	# Enable only the collision shapes of the active direction
	if active_sprite:
		var hurtbox = active_sprite.get_node_or_null('Hurtbox/CollisionShape2D')
		var hitbox = active_sprite.get_node_or_null('Hitbox/CollisionShape2D')
		if hurtbox: hurtbox.set_deferred("disabled", false)
		if hitbox: hitbox.set_deferred("disabled", false)

	# Disable collision shapes for all non-active sprites
	for dir_name in direction_map.values():
		if dir_name != active_dir:
			var sprite = segment.get_node_or_null(dir_name)
			if sprite:
				var hurtbox = sprite.get_node_or_null('Hurtbox/CollisionShape2D')
				var hitbox = sprite.get_node_or_null('Hitbox/CollisionShape2D')
				if hurtbox: hurtbox.set_deferred("disabled", true)
				if hitbox: hitbox.set_deferred("disabled", true)

func update_direction2(segment, new_direction, is_head=false):
	if is_head:
		var dir_str = direction_map.get(direction, "")
		snake[0].get_node("AnimatedSprite2D").play(dir_str)


func spawn_snake():
	var pos = start_pos

	# Spawn head
	var head = s_head2.instantiate()
	head.position = pos
	head.z_index = snake_size
	add_child(head)
	snake.append(head)

	# Set initial direction for head
	head.set_meta("direction", Vector2.LEFT)  # Set initial direction of head
	update_direction2(head, Vector2.LEFT, true)  # Update head's sprite based on its direction
	head.get_node("Hurtbox").health_component = hp
	head.get_node("Hitbox").set_deferred("disabled", true)

	pos.x += segment_size  # Move position for next segment

	# Spawn alternating body segments
	for i in range(snake_size-2):
		var body_part = s_weak_body.instantiate() if (i+1) % 3 == 0 else s_body.instantiate()
		body_part.position = pos
		body_part.z_index = snake_size-1-i
		add_child(body_part)
		snake.append(body_part)
		
		body_part.set_meta("direction", Vector2.LEFT)  # Set initial direction of head
		update_direction(body_part, Vector2.LEFT)
		
		pos.x += segment_size  # Move position

	# Spawn tail
	var tail = s_tail.instantiate()
	tail.position = pos
	tail.z_index = 1
	add_child(tail)
	snake.append(tail)

	# Set initial direction for tail
	tail.set_meta("direction", Vector2.LEFT)  # Set initial direction of head
	update_direction(tail, Vector2.LEFT)  # Update tail's sprite based on its direction

func chase_player(player_position: Vector2):
	var direction_to_player = player_position - snake[0].global_position
	
	# If the snake is very close, stop moving
	if direction_to_player.length() < segment_size and can_bite:
		bite_attack()
	
	if direction_to_player.length() >= 300 and can_spit:
		spit_attack()

	var rand_dir = randi() % 16
	if rand_dir == 0:
		direction = Vector2.RIGHT
	elif rand_dir == 1:
		direction = Vector2.LEFT
	elif rand_dir == 2:
		direction = Vector2.DOWN
	elif rand_dir == 3:
		direction = Vector2.UP
	else:# Snap to cardinal direction
		if abs(direction_to_player.x) > abs(direction_to_player.y):
			direction = Vector2.RIGHT if direction_to_player.x > 0 else Vector2.LEFT
		else:
			direction = Vector2.DOWN if direction_to_player.y > 0 else Vector2.UP

func z_indexing():
	for i in range(snake.size()):
		snake[i].z_index = snake.size() - i
		
	for i in range(snake.size() - 1):
		if snake[i].position.y < snake[i + 1].position.y:
			snake[i].z_index -= 1
			snake[i + 1].z_index += 1

func bite_attack():
	can_move = false
	can_bite = false
	var dir_str = direction_map.get(direction, "")
	print("BITE")
	dir_str += '_Bite'
	snake[0].get_node("AnimatedSprite2D/AnimationPlayer").play(dir_str)
	await get_tree().create_timer(2.0).timeout
	can_move = true
	await get_tree().create_timer(2.0).timeout
	can_bite = true

func spit_attack():
	can_move = false
	can_spit = false
	print("SPIT")
	await get_tree().create_timer(2.0).timeout
	can_move = true
	await get_tree().create_timer(5.0).timeout
	can_spit = true

func _on_venom_timer_timeout() -> void:
	can_spit = true
	
func enter_rage_mode():
	$MoveTimer.wait_time = .15

func _on_health_component_death() -> void:
	#Play death animation
	
	queue_free()
