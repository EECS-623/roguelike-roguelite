extends Node
@onready var player : Player = $"../.."
# Called when the node enters the scene tree for the first time.
var upgrade_level = 2
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var teleport = true
var teleport_amount = 300
var teleport_begun = false

func _process(delta: float) -> void:
	var camera = $"../../Camera2D"
	if Input.is_action_just_pressed("right_click") and Global.patron_god == 3:
		if upgrade_level == 1:
			if teleport:
				
				var teleport_position = player.direction*teleport_amount
				var collision = player.move_and_collide(teleport_position, true)
				if not collision:
					teleport_begun = true
					camera.position_smoothing_enabled = true
					player.global_position += teleport_position
					teleport = false
					await get_tree().create_timer(3).timeout
					teleport = true
					teleport_begun = false
					camera.position_smoothing_speed = 18
					await get_tree().create_timer(2).timeout
					if not teleport_begun:
						camera.position_smoothing_enabled = false
					
		if upgrade_level == 2:
			if teleport:
				var start_position = player.global_position
				var teleport_vector = player.direction * teleport_amount
				var end_position = start_position + teleport_vector

				# Try to move (so you don't phase through walls)
				var collision = player.move_and_collide(teleport_vector, true)
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
					query.exclude = [player]			# don’t hit yourself
					query.collide_with_bodies = true	# include PhysicsBody2D
					query.collide_with_areas = true		# include Area2D (if your Hitbox is one)
					query.collision_mask = (1 << 0) | (1 << 2)  # Layers 1 and 3
		# make sure this matches your ENEMY layer

					# Actually do the query (limit to 32 hits just in case)
					var results = player.get_world_2d().direct_space_state.intersect_shape(query, 32)
					print("Teleport hit count: ", results.size())

					# ────── 2) APPLY DAMAGE ──────
					for r in results:
						var enemy = r.collider
						print(enemy)
						
						# If the enemy *has a Hitbox child*, you can trigger it:
						var health = enemy.get_node_or_null("HealthComponent")
						if health:
							health.take_damage(150)
								#hitbox.emit_signal("hit", player)
							print("gothere")
						# OR, if you want to use your Hitbox system:
						# var hb = Hitbox.new()
						# hb.is_magic = false
						# hb.damage = 1000
						# hb.emit_signal("hit", enemy)

					# ────── 3) COMPLETE THE TELEPORT ──────
					teleport_begun = true
					camera.position_smoothing_enabled = true
					player.global_position = end_position
					teleport = false

					await get_tree().create_timer(3).timeout
					teleport = true
					teleport_begun = false
					camera.position_smoothing_speed = 18

					await get_tree().create_timer(2).timeout
					if not teleport_begun:
						camera.position_smoothing_enabled = false

					
					
					
					
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
