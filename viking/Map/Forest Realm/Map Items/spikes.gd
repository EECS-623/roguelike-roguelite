
extends Sprite2D
@export var player: PackedScene = preload("res://Entities/Player/player.tscn")


func _ready() -> void:
	var scale = randf()
	scale = 0.05 + 0.05* scale 
	
	set_scale(Vector2(scale,scale))
	#z_index = -1	
	
	while(true):
		$Hitbox/CollisionShape2D.disabled = true

		await get_tree().create_timer(2).timeout
		$Hitbox/CollisionShape2D.disabled = false
		
		await get_tree().create_timer(2).timeout


		
		
	
	
