extends Sprite2D

func _ready() -> void:
	var scale = randf()
	scale = 0.1 + 0.1* scale 
	
	set_scale(Vector2(scale,scale))
	z_index = -1	
