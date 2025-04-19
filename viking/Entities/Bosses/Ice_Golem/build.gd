class_name Build extends State

@onready var idle : State = $"../Idle"

@export var s_icicle: PackedScene = preload("res://Entities/Bosses/Ice_Golem/icicle.tscn")

var finished
var ice_golem
var player


func enter() -> void:
	finished = false
	#ice_golem.update_animation("build")
	spawn_wall()
	if Vector2(0, -385).distance_to(player.global_position) > 200:
		var pattern = randi_range(0, 3)
		if pattern == 0:
			spawn_snowflake_pattern()
		elif pattern == 1:
			spawn_line_to_player()
		elif pattern == 2:
			spawn_closing_circle()
		elif pattern == 3:
			spawn_opening_circle()

	await get_tree().create_timer(5).timeout
	
	finished = true


func state_process(delta : float) -> State:
	if finished:
		return idle
	return null


func spawn_icicle(position: Vector2, wall = false):
	if not is_position_blocked(position):
		var icicle = s_icicle.instantiate()
		icicle.global_position = position
		icicle.wall = wall
		icicle.add_to_group("icicles")
		add_child(icicle)

func is_position_blocked(pos: Vector2) -> bool:
	for child in get_children():
		if child is Icicle and child.global_position.distance_to(pos) < 45:
			child.shatter()
			return false
	
	var space_state = player.get_world_2d().get_direct_space_state()
	var point = PhysicsPointQueryParameters2D.new()	
	point.position = pos
	var result = space_state.intersect_point(point)

	for collision in result:
		if collision.collider is StaticBody2D:
			return true
	
	return false


func spawn_snowflake_pattern(spokes := 6, steps := 4, spacing := 50):
	var player_position = player.global_position
	spawn_icicle(player_position)
	for i in range(spokes):
		var dir = Vector2.RIGHT.rotated(TAU * i / spokes)
		for j in range(1, steps+1):
			var offset = dir * spacing * j
			var pos = player_position + offset
			spawn_icicle(pos)
		await get_tree().create_timer(.2).timeout


func spawn_line_to_player(spacing := 75.0):
	var start1 = Vector2(0, -300)
	var start2 = Vector2(75, -300)
	var start3 = Vector2(-75, -300)
	var direction = (player.global_position - start1).normalized()
	var distance = start1.distance_to(player.global_position)
	var steps = int(distance / spacing)
	for i in range(steps):
		var pos1 = start1 + direction * (i * spacing)
		spawn_icicle(pos1)
		var pos2 = start2 + direction * (i * spacing)
		spawn_icicle(pos2)
		var pos3 = start3 + direction * (i * spacing)
		spawn_icicle(pos3)
		await get_tree().create_timer(.1).timeout

func spawn_circle(radius: float, count: int, player_position):
	for i in count:
		var angle = i * TAU / count
		var offset = Vector2(cos(angle), sin(angle)) * radius
		spawn_icicle(player_position + offset)
		
func spawn_closing_circle(rings = 2):
	var player_position = player.global_position
	for i in range(rings, 0, -1):
		spawn_circle((50+ 75*i) ,(6 + 6*i), player_position)
		await get_tree().create_timer(2).timeout
	spawn_icicle(player_position)

func spawn_opening_circle(rings = 3):
	var player_position = player.global_position
	spawn_icicle(player_position)
	await get_tree().create_timer(1).timeout
	for i in range(1, rings):
		spawn_circle((50*i),(6*i), player_position)
		await get_tree().create_timer(1).timeout

func spawn_wall(center := Vector2(0, -385), width := 380.0, rows := 2, vertical_amplitude := 40.0, spacing := 50.0):
	var start_x = -width / 2
	var end_x = width / 2
	var points_per_row = int(width / spacing) + 1

	for row in range(rows):
		var vertical_offset = row * 55.0  # space between rows

		for i in range(points_per_row):
			var t = i / float(points_per_row - 1)
			var x = lerp(start_x, end_x, t)
			var y = sin(t * PI) * vertical_amplitude + vertical_offset
			var pos = center + Vector2(x, y)
			spawn_icicle(pos, true)
			await get_tree().create_timer(0.01).timeout
