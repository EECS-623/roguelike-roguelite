class_name Arrow extends Area2D
var direction: Vector2

# Called when the node enters the scene tree for the first time.
var cursor_position
var rotation_angle

func _ready() -> void:
	#add_to_group("player")
	##direction = direction.normalized()
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 1.0
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * Global.bullet_speed * delta

	
func _on_hitbox_hit(body: Variant) -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()  
