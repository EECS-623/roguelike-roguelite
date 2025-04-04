class_name Fireball extends Area2D
var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player")
	#direction = direction.normalized()
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 1.0
	timer.connect("timeout", _on_timer_timeout)
	timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(direction)
	position += direction * Global.bullet_speed * delta

func _on_hitbox_hit(body: Variant) -> void:
	await get_tree().create_timer(0.25).timeout
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()  
