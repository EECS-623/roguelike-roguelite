extends Node2D

@export var s_head: PackedScene
@export var s_body: PackedScene
@export var s_weak_body: PackedScene
@export var s_tail: PackedScene

@export var move_timer: Timer
@export var venom_timer: Timer
@export var bite_timer: Timer
@onready var hp : HealthComponent = $HealthComponent

var snake: Array = []
var direction = Vector2.LEFT

# Starting position
var start_pos: Vector2 = Vector2(500, 500)  
var segment_size = 100  
var snake_size = 10

var can_move = true
var can_bite = true
var can_spit = false

#signal dead()

func _ready() -> void:
	# Connect the move timer signal
	spawn_snake()
	
	for part in snake:
		if part.name == "SnakeHead" or part.name == "SnakeBodyWeak":
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
		update_direction(snake[0], direction)
		z_indexing()
		if (hp.current_health <= (hp.max_health / 2)):
			enter_rage_mode()
		print(hp.current_health)

func update_direction(segment, new_direction):
	# Here we assume each segment has a `direction` property and the sprite nodes are named for the directions
	# Hide all sprites first
	for node in ['Left', 'Right', 'Down', 'Up']:
		segment.get_node(node).visible = false
	
	# Show the sprite corresponding to the new direction
	if new_direction == Vector2.LEFT:
		segment.get_node('Left').visible = true
	elif new_direction == Vector2.RIGHT:
		segment.get_node('Right').visible = true
	elif new_direction == Vector2.UP:
		segment.get_node('Up').visible = true
	elif new_direction == Vector2.DOWN:
		segment.get_node('Down').visible = true


func spawn_snake():
	var pos = start_pos

	# Spawn head
	var head = s_head.instantiate()
	head.position = pos
	head.z_index = snake_size
	add_child(head)
	snake.append(head)

	# Set initial direction for head
	head.set_meta("direction", Vector2.LEFT)  # Set initial direction of head
	update_direction(head, Vector2.LEFT)  # Update head's sprite based on its direction

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

#func chase_player1(player_position: Vector2):
	#var direction_to_player = player_position - snake[0].global_position
	#snake[0].get_node("Debug").text = "Rahhhhhh"
#
	## If the snake is very close, stop moving
	#if direction_to_player.length() < segment_size:
		#can_move = false
	#else:
		#can_move = true
#
	## Store the current direction to check for backtracking
	#var possible_directions = []
	#
	## Add valid directions (excluding the opposite direction)
	#if direction != Vector2.RIGHT: possible_directions.append(Vector2.LEFT)
	#if direction != Vector2.LEFT: possible_directions.append(Vector2.RIGHT)
	#if direction != Vector2.DOWN: possible_directions.append(Vector2.UP)
	#if direction != Vector2.UP: possible_directions.append(Vector2.DOWN)
#
	## Remove directions that would collide with the snake's body
	#possible_directions = possible_directions.filter(func(dir):
		#return not is_occupied(snake[0].position + dir * segment_size)
	#)
#
	## If no valid moves, just continue in the current direction
	#if possible_directions.is_empty():
		#return  
#
	## Pick the best available direction
	#var new_direction = direction  # Default to current direction
	#if possible_directions.size() == 1:
		#new_direction = possible_directions[0]  # Only one valid move
	#else:
		## Prioritize moving towards the player
		#var best_direction = possible_directions[0]
		#var best_distance = (snake[0].position + best_direction * segment_size - player_position).length()
		#for dir in possible_directions:
			#var distance = (snake[0].position + dir * segment_size - player_position).length()
			#if distance < best_distance:
				#best_distance = distance
				#best_direction = dir
		#new_direction = best_direction
	#
	#direction = new_direction  # Set the final direction
#
#func is_occupied(pos: Vector2) -> bool:
	#for segment in snake:
		#if segment.position == pos:
			#return true
	#return false

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
	print("BITE")
	await get_tree().create_timer(2.0).timeout
	can_move = true
	await get_tree().create_timer(2.0).timeout
	can_bite = true

func spit_attack():
	can_move = false
	can_spit = false
	print("SPIT")
	await get_tree().create_timer(1.0).timeout
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
