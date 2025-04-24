
extends Sprite2D
@export var player: PackedScene = preload("res://Entities/Player/player.tscn")


func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	print("apple created")
	
	
	var scale = randf()
	scale = 0.1
	
	set_scale(Vector2(scale,scale))
	z_index = -1	
	
	


func _on_body_entered(body):
	print("apple entered")
	
	if not body.is_in_group("player"):
		return
		
	await get_tree().create_timer(0.05).timeout	
	$Hitbox/CollisionShape2D.disabled = true
	
	print("apple eaten")
	
	queue_free()

		
	
	
