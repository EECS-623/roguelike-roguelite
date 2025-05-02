extends Node2D

@export var s_projectile: PackedScene

var player

var delay


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while true:
		await get_tree().create_timer(delay).timeout
		var direction_to_player = (player.global_position - global_position).normalized()
		update_animation("projectile", direction_to_player)
		await get_tree().create_timer(.5).timeout
		var projectile = s_projectile.instantiate()
		projectile.player = player
		projectile.global_position = $AnimatedSprite2D/Muzzle.global_position
		projectile.get_node("Hitbox").damage = 10
		get_tree().current_scene.add_child(projectile)
		await get_tree().create_timer(1).timeout

func update_animation(animation, direction = Vector2.DOWN):
	var animation_direction
	if abs(direction.x) > abs(direction.y):
		animation_direction = "right" if direction.x > 0 else "left"
	else:
		animation_direction = "down" if direction.y > 0 else "up"
	$AnimationPlayer.play(animation+"_"+animation_direction)


func destroy():
	queue_free()


func _on_health_component_death() -> void:
	destroy()
