extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group("player_bullet")):
		print("enemy_hit")
		queue_free()
		area.queue_free()
		await get_tree().create_timer(0.2).timeout
