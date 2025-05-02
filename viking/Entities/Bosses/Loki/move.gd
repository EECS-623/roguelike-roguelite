class_name Move extends State

var player : CharacterBody2D
var loki : CharacterBody2D

var move_timer
var change_dir_timer

var speed = 200

var close_thresh = 50
var far_thresh = 700

var close_actions = ["Teleport", "Move", "Move", "Move"]
var actions = ["Teleport", "Summon", "Clone", "SpellCircle", "MakeSpikes"]

# what happens when the entity enters a state
func enter() -> void:
	move_timer = randf_range(5, 10)
	change_dir_timer = randf_range(.1, .75)

# what happens when the entity exits a state
func exit() -> void:
	pass


func state_physics_process(delta: float) -> State:
	move_timers(delta)
	
	if move_timer <= 0:
		return choose_state()

	return null

func move_timers(delta: float):
	move_timer -= delta
	change_dir_timer -= delta
	
	if change_dir_timer <= 0:
		loki.velocity = move()
		change_dir_timer = randf_range(.1, .75)
	
	loki.move_and_slide()

func get_state_by_name(name: String) -> State:
	for state in get_parent().states:
		if state.name == name:
			return state
	return null
	
func choose_state():
	var new_state
	var distance_to_player = loki.global_position.distance_to(player.global_position)
	if distance_to_player < close_thresh:
		#new_state = close_actions[randi_range(0, 4)]
		new_state = "Move"
	else:
		new_state = actions[randi_range(0, 4)]

	
	return get_state_by_name(new_state)
	
func move():
	var direction_to_player = (player.global_position - loki.global_position).normalized()
	var distance_to_player = loki.global_position.distance_to(player.global_position)
	var animation_direction
	var move_dir
	var move_speed = speed

	#Retreat and strafe (fast)
	if distance_to_player < 200:
		move_dir = -1 * direction_to_player
		move_dir += direction_to_player.orthogonal().normalized() * (1  if randf() > 0.5 else -1)
		move_speed *= 1.1
	
	#Too far, approach and strafe
	elif distance_to_player > far_thresh:
		move_dir = direction_to_player
		move_dir += direction_to_player.orthogonal().normalized() * (1  if randf() > 0.5 else -1)
		move_speed *= .9
		
	#Ideal, Strafe
	else:
		move_dir = direction_to_player.orthogonal().normalized() * (1  if randf() > 0.5 else -1)
		move_speed *= .8
	
	move_dir = find_clear_direction(move_dir)

	loki.update_animation("move", move_dir)
		
	return (move_dir * move_speed)
	

#This function is to help avoiding getting cornered
#It looks for directions near move_dir without many collision shapes
#It also rewards heading towards the center of the map
func find_clear_direction(base_dir: Vector2) -> Vector2:
	var best_dir = base_dir
	var best_score = -INF
	var center = Vector2(0, 0)  # or your actual map center

	for i in range(8):
		var angle = deg_to_rad(i * 45) # Check in 45° increments
		var dir = base_dir.rotated(angle).normalized()
		var offset = dir * 50
		var new_pos = loki.global_position + offset

		if not loki.test_move(loki.transform, offset):
			var closeness_score = 1.0 - (new_pos.distance_to(center) / 1000.0) # tweak divisor for weight
			var angle_score = 1.0 - abs(angle) / PI
			var score = angle_score + closeness_score

			if score > best_score:
				best_score = score
				best_dir = dir

	return best_dir

func can_move_during():
	return true
