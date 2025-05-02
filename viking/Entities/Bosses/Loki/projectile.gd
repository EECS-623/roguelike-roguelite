extends Node2D

@export var speed: float = 500.0

var player
var player_dir

var starting_pos



func _ready() -> void:
	Wwise.post_event_id(AK.EVENTS.ARROW_FIRE, self)
	starting_pos = global_position
	look_at(player.global_position)


func _physics_process(delta):
	if player !=null:
		if player_dir == null:
			player_dir = (player.global_position - global_position).normalized()

		var distance = speed * delta

		if (global_position.distance_to(starting_pos) < 2000):
			global_position += player_dir * distance
		else:
			queue_free()
			

func _on_hitbox_hit(body: Variant) -> void:
	queue_free()
