class_name Fireball extends Area2D
var direction: Vector2

# Called when the node enters the scene tree for the first time.
var cursor_position
var rotation_angle

func _ready() -> void:
	#add_to_group("player")
	##direction = direction.normalized()
	$AnimatedSprite2D.play("lightning")
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 2.0
	timer.connect("timeout", _on_timer_timeout)
	timer.start()
	#cursor_position = get_global_mouse_position()
	#rotation_angle = to_local(position).angle_to_point(cursor_position)
	#rotation = rotation_angle


#func launch():
	##direction = direction.normalized()
	#var timer = Timer.new()
	#add_child(timer)
	#timer.one_shot = true
	#timer.wait_time = 1.0
	#timer.connect("timeout", _on_timer_timeout)
	#timer.start()
	#rotation = (get_global_mouse_position() - global_position).angle()


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	print(direction)
	position += direction * Global.bullet_speed * delta * 3

	
func _on_hitbox_hit(body: Variant) -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()  
