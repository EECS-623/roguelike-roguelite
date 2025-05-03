
extends Sprite2D
@export var player: PackedScene = preload("res://Entities/Player/player.tscn")


func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	print("apple created")
	
	
	var scale = randf()
	scale = 0.05
	
	set_scale(Vector2(scale,scale))
	z_index = -1	
	
	


func _on_body_entered(body):
	print("apple entered")
	print(body)
	
	if not body.is_in_group("player"):
		return
	
	var health_component = body.get_node("HealthComponent")
	
	if health_component.max_health == health_component.current_health:
		return
	
	health_component.increase_current_health(10)
	await get_tree().create_timer(0.05).timeout	
	
	print("apple eaten")
	Wwise.post_event_id(AK.EVENTS.APPLE_HEAL, self)
	
	queue_free()
		
	
	
