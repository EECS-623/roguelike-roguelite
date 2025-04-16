extends Node2D

@export var speed: float = 700.0

var player
var player_dir

var starting_pos

var tween: Tween
var slowed = false

func _ready() -> void:
	var slowed = false
	starting_pos = global_position


func _physics_process(delta):
		if player !=null:
			if player_dir == null:
				player_dir = (player.global_position - global_position).normalized()

			var distance = speed * delta

			if (global_position.distance_to(starting_pos) < 2000):
				global_position += player_dir * distance
			else:
				var slowed = false
				queue_free()

func _on_hitbox_hit(body: Variant) -> void:
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)

	if tween and tween.is_running():
		return  # prevent sliding again mid-tween

	var end_pos = player.global_position + player_dir * 30

	tween = create_tween()
	tween.tween_property(player, "global_position", end_pos, .3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	if not slowed:
		slowed = true
		player.modulate = Color.SKY_BLUE
		var speed_component = player.get_node("SpeedComponent")
		var orig_speed = speed_component.get_speed()
		speed_component.set_speed(orig_speed * 0.5)
		
		await get_tree().create_timer(1.5).timeout

		player.modulate = Color.WHITE
		speed_component.set_speed(orig_speed)
		slowed = false
		queue_free()
