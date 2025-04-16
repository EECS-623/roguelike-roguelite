class_name Icicle extends CharacterBody2D

func _ready():
	$AnimationPlayer.play("spawn")
	pass

	
func shatter():
	$AnimationPlayer.play("shatter")
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _on_health_component_death() -> void:
	shatter()


func _on_health_component_t_damage(amount: float) -> void:
	print("HELLO")
	$AnimationPlayer.play("hit")
	await get_tree().create_timer(.5).timeout
