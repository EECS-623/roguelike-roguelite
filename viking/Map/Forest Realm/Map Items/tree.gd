extends Sprite2D

func _ready() -> void:
	var scale = randf()
	scale = 0.125 + 0.125* scale 
	
	set_scale(Vector2(scale,scale))
	z_index = -1	
