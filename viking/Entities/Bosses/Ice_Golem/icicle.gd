class_name Icicle extends CharacterBody2D

var melt_timer
var wall = false

func _ready():
	$AnimationPlayer.play("spawn")
	melt_timer = randf_range(4, 10)

func _process(delta):
	melt_timer -= delta
	if melt_timer <= 0 and not wall:
		shatter()
		melt_timer = 100

func shatter():
	$AnimationPlayer.play("shatter")
	await $AnimationPlayer.animation_finished
	Wwise.post_event_id(AK.EVENTS.ICICLE_BREAK, self)
	queue_free()

func _on_health_component_death() -> void:
	shatter()


func _on_health_component_t_damage(amount: float) -> void:
	$AnimationPlayer.play("hit")
	await $AnimationPlayer.animation_finished
