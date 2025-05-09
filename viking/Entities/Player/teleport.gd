extends SpecialAbilityComponent
@onready var player : Player = $"../.."
# Called when the node enters the scene tree for the first time.

@onready var mana_component = $"../../ManaComponent"
var mana_cost: float = 40.0  # Teleport costs 40 mana

@onready var camera = $"../../Camera2D"

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var teleport = true
var teleport_amount = 300
var teleport_begun = false





					
					
					
					
				#print(camera.global_position.distance_to(camera.get_target_position()))
				#if camera.global_position.distance_to(camera.get_target_position()) < 1:
					#camera.position_smoothing_enabled = false
	#teleport anywhere script
	#if teleport:
		#position = get_global_mouse_position()
		#teleport = false
		#await get_tree().create_timer(3).timeout
		#teleport = true
		#this was the teleport where it took you anywhere
func upgrade_ability():
	teleport_amount += 50

func cast_ability() -> bool:
	# Try to use mana first
	if (mana_component.current_mana - mana_cost < 0) or Global.teleport_banned:
		return false # Not enough mana or teleport banned like in valhalla
	
	# move over ability logic here
	
	var offsets = [
		# First ring (short range)
		Vector2(0, 30), Vector2(30, 0), Vector2(-30, 0), Vector2(0, -30),
		Vector2(30, 30), Vector2(-30, -30), Vector2(30, -30), Vector2(-30, 30),

		# Second ring (medium range)
		Vector2(50, 0), Vector2(-50, 0), Vector2(0, 50), Vector2(0, -50),
		Vector2(50, 50), Vector2(-50, -50), Vector2(50, -50), Vector2(-50, 50),

		# Third ring (wider square)
		Vector2(70, 0), Vector2(-70, 0), Vector2(0, 70), Vector2(0, -70),
		Vector2(70, 70), Vector2(-70, -70), Vector2(70, -70), Vector2(-70, 70),

		# Fourth ring (even wider)
		Vector2(100, 0), Vector2(-100, 0), Vector2(0, 100), Vector2(0, -100),
		Vector2(100, 100), Vector2(-100, -100), Vector2(100, -100), Vector2(-100, 100),

		# Diagonal steps between main rings
		Vector2(60, 30), Vector2(-60, -30), Vector2(60, -30), Vector2(-60, 30),
		Vector2(30, 60), Vector2(-30, -60), Vector2(30, -60), Vector2(-30, 60),

		# Wide diagonals
		Vector2(90, 90), Vector2(-90, -90), Vector2(90, -90), Vector2(-90, 90),
		Vector2(80, 40), Vector2(-80, -40), Vector2(80, -40), Vector2(-80, 40),
		Vector2(40, 80), Vector2(-40, -80), Vector2(40, -80), Vector2(-40, 80)
	]
	offsets.shuffle()

	if Global.patron_god == 3:
		if Global.upgrade_level == 1:
			if teleport:
				# Use facing_direction when player isn't moving
				var teleport_dir = player.direction
				if teleport_dir == Vector2.ZERO:
					teleport_dir = player.facing_direction
				
				var teleport_position = teleport_dir * teleport_amount
				var collision = player.move_and_collide(teleport_position, true)
				if collision:
					for offset in offsets:
						var new_teleport_position = teleport_position + offset
						collision = player.move_and_collide(new_teleport_position, true)
						if not collision:
							teleport_position = new_teleport_position
							break

							
				if not collision:
					teleport_begun = true
					camera.position_smoothing_enabled = false
					var old_camera_position = camera.global_position
					player.global_position += teleport_position
					
					start_camera_lerp(old_camera_position, player.global_position)
					
					teleport = false
					mana_component.use_mana(mana_cost)
					#await get_tree().create_timer(3).timeout
					teleport = true
					teleport_begun = false
					#camera.position_smoothing_speed = 18
					#await get_tree().create_timer(2).timeout
					#if not teleport_begun:
					#	camera.position_smoothing_enabled = false
					
		if Global.upgrade_level == 2:
			if teleport:
				var start_position = player.global_position
				
				# Use facing_direction when player isn't moving
				var teleport_dir = player.direction
				if teleport_dir == Vector2.ZERO:
					teleport_dir = player.facing_direction
						
				var teleport_vector = teleport_dir * teleport_amount
				var end_position = start_position + teleport_vector

				# Try to move (so you don't phase through walls)
				var collision = player.move_and_collide(teleport_vector, true)
				if collision:
					for offset in offsets:
						var new_teleport_vector = teleport_vector + offset
						collision = player.move_and_collide(new_teleport_vector, true)
						if not collision:
							end_position = new_teleport_vector + start_position
							break
				if not collision:
					# ────── 1) SHAPE QUERY SETUP ──────
					var path_length = teleport_vector.length()
					var path_dir = teleport_vector.normalized()
					var half_length = path_length * 0.5
					var width = 10  # adjust as needed

					# Rectangle from start→end, centered halfway
					var rect_shape = RectangleShape2D.new()
					rect_shape.extents = Vector2(half_length+200, width+200)

					# Transform2D(angle, origin)
					var angle = path_dir.angle()
					var origin = (start_position + end_position) * 0.5
					var xform = Transform2D(angle, origin)

					var query = PhysicsShapeQueryParameters2D.new()
					query.shape = rect_shape
					query.transform = xform
					query.exclude = [player]				# don't hit yourself
					query.collide_with_bodies = true		# include PhysicsBody2D
					query.collide_with_areas = true			# include Area2D (if your Hitbox is one)
					query.collision_mask = (1 << 0) | (1 << 2)  # Layers 1 and 3
		# make sure this matches your ENEMY layer
					
					# Actually do the query (limit to 32 hits just in case)
					var results = player.get_world_2d().direct_space_state.intersect_shape(query, 32)
					print("Teleport hit count: ", results.size())

					
						# OR, if you want to use your Hitbox system:
						# var hb = Hitbox.new()
						# hb.is_magic = false
						# hb.damage = 1000
						# hb.emit_signal("hit", enemy)

					# ────── 2) APPLY DAMAGE ──────
					var enemies_to_free = []
					for r in results:
						var enemy = r.collider
						print(enemy)

						# If the enemy *has a Hitbox child*, you can trigger it:
						if enemy:
							var health = enemy.get_node_or_null("HealthComponent")
							if health:
								enemy.modulate = Color(1,0,0)
								enemies_to_free.append(health)
								#health.take_damage(150)
								#hitbox.emit_signal("hit", player)
								print("gothere")
					# ────── 3) COMPLETE THE TELEPORT ──────
					teleport_begun = true
					camera.position_smoothing_enabled = false
					mana_component.use_mana(mana_cost)
					var old_camera_position = camera.global_position
					player.global_position = end_position
					teleport = false
					start_camera_lerp(old_camera_position, player.global_position)
					
					await get_tree().create_timer(.5).timeout
					for selected_enemy in enemies_to_free:
						selected_enemy.take_damage(150)

					teleport = true
					teleport_begun = false
	
	return true # this will be at the very end of the function

func start_camera_lerp(from_position: Vector2, to_position: Vector2):
	async_camera_lerp(from_position, to_position)

func async_camera_lerp(from_position: Vector2, to_position: Vector2):
	var lerp_time := 0.0
	var duration := 0.3
	
	while lerp_time < duration:
		lerp_time += get_process_delta_time()
		var t := lerp_time / duration
		camera.global_position = from_position.lerp(to_position, t)
		await get_tree().process_frame
	
	camera.global_position = to_position
	camera.position_smoothing_enabled = true
