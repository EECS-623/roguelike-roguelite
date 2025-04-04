extends Node2D

@export var speed: float = 500.0
@export var puddle_duration: float = 5.0

var target_position: Vector2
var moving = true
var total_distance

func _process(delta):
	if moving:
		var direction = (target_position - global_position).normalized()
		var distance = speed * delta
		var distance_to_target = global_position.distance_to(target_position)

		if distance_to_target > distance:
			position += direction * distance

			var progress = 1.0 - (distance_to_target / total_distance)

			if progress >= 0.33:
				$AnimatedSprite2D.play("Middle")

			if progress >= 0.66:
				$AnimatedSprite2D.play("End")
		else:
			position = target_position
			stop_moving()

func shoot(target_pos: Vector2):
	target_position = target_pos
	moving = true
	total_distance = global_position.distance_to(target_position)
	$AnimatedSprite2D.look_at(target_position)
	$AnimatedSprite2D.rotation_degrees -= 90
	
	$VenomPuddle.hide()  # Hide puddle initially
	$AnimatedSprite2D.play("Start")  # Play shooting animation
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)

func stop_moving():
	moving = false
	$Hitbox/CollisionShape2D.set_deferred("disabled", false)
	$AnimatedSprite2D.hide()  # Hide the projectile
	$VenomPuddle.show()  # Show puddle
	for i in range(5):
		await get_tree().create_timer(1).timeout
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$Hitbox/CollisionShape2D.set_deferred("disabled", false)
	queue_free()  # Remove venom instance
 # Replace with function body.
